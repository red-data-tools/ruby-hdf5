module HDF5
  class Dataset
    class << self
      def create(parent_id, name, data = nil, shape: nil, dtype: nil, maxshape: nil, chunks: nil, compression: nil,
                 compression_opts: nil, shuffle: false, fletcher32: false, fillvalue: nil, context: nil)
        empty_data = data.is_a?(HDF5::Empty)
        string_data = HDF5::StringCodec.string_data?(data)
        _string_values, string_shape = HDF5::StringCodec.normalize_data(data) if string_data
        unless data.nil? || string_data || empty_data
          narray = HDF5::DataHelpers.normalize_data(data,
                                                    label: 'Dataset data')
        end
        unless string_data
          dtype_object = if empty_data
                           data.dtype
                         else
                           (dtype ? DType.for_symbol(dtype) : DType.for_numo(narray))
                         end
        end
        type_id = string_data ? HDF5::StringCodec.datatype_id : dtype_object.storage_type_id
        shape = string_data ? string_shape : narray.shape if shape.nil? && !data.nil? && !empty_data
        raise HDF5::Error, 'shape: and dtype: are required when data: is omitted' if data.nil? && (!shape || !dtype)
        raise HDF5::Error, 'Dataset shape must match data shape' if narray && shape != narray.shape
        raise HDF5::ShapeError, 'Dataset shape must match string data shape' if string_data && shape != string_shape

        raise HDF5::Error, 'Null datasets cannot have maxshape or chunks' if empty_data && (maxshape || chunks)

        validate_maxshape(maxshape, shape) if maxshape
        chunks = :auto if maxshape && chunks.nil?
        dataspace_id = create_dataspace(shape, maxshape)
        raise HDF5::Error, "Failed to create dataspace for dataset: #{name}" if dataspace_id < 0

        dcpl_id = create_property_list(shape, dtype_object, chunks:, compression:, compression_opts:, shuffle:, fletcher32:,
                                                            fillvalue:)

        dataset = from_id(
          HDF5::FFI.H5Dcreate2(parent_id, name, type_id, dataspace_id, HDF5::DEFAULT_PROPERTY_LIST,
                               dcpl_id || HDF5::DEFAULT_PROPERTY_LIST, HDF5::DEFAULT_PROPERTY_LIST), name, context
        )
        dataset.write(data) if string_data
        dataset.write(narray) if narray
        return dataset unless block_given?

        begin
          yield dataset
        ensure
          dataset.close
        end
      rescue StandardError
        if dataset
          dataset.close unless dataset.closed?
          HDF5::FFI.H5Ldelete(parent_id, name, HDF5::DEFAULT_PROPERTY_LIST)
        end
        raise
      ensure
        HDF5::FFI.H5Tclose(type_id) if string_data && type_id && type_id >= 0
        HDF5::FFI.H5Pclose(dcpl_id) if dcpl_id && dcpl_id >= 0
        HDF5::FFI.H5Sclose(dataspace_id) if dataspace_id && dataspace_id >= 0
      end

      def open(parent_id, name, context: nil)
        dataset = from_id(HDF5::FFI.H5Dopen2(parent_id, name, HDF5::DEFAULT_PROPERTY_LIST), name, context)
        return dataset unless block_given?

        begin
          yield dataset
        ensure
          dataset.close
        end
      end

      private

      def create_dataspace(shape, maxshape = nil)
        return HDF5::FFI.H5Screate(:H5S_NULL) if shape.nil?
        return HDF5::FFI.H5Screate(:H5S_SCALAR) if shape.empty?

        dims = ::FFI::MemoryPointer.new(:ulong_long, shape.length)
        dims.write_array_of_ulong_long(shape)
        maxdims = if maxshape
                    ::FFI::MemoryPointer.new(:ulong_long, maxshape.length).tap do |pointer|
                      pointer.write_array_of_ulong_long(maxshape.map do |dimension|
                        dimension.nil? ? unlimited_dimension : dimension
                      end)
                    end
                  end
        HDF5::FFI.H5Screate_simple(shape.length, dims, maxdims)
      end

      def validate_maxshape(maxshape, shape)
        unless maxshape.is_a?(Array) && maxshape.length == shape.length
          raise HDF5::Error,
                'maxshape must be an Array matching dataset rank'
        end

        valid = maxshape.zip(shape).all? do |maximum, dimension|
          maximum.nil? || maximum.is_a?(Integer) && maximum >= dimension
        end
        raise HDF5::Error, 'maxshape dimensions must be nil or integers no smaller than shape' unless valid
      end

      def unlimited_dimension
        (1 << (::FFI.type_size(:ulong_long) * 8)) - 1
      end

      def create_property_list(shape, dtype_object, chunks:, compression:, compression_opts:, shuffle:, fletcher32:,
                               fillvalue:)
        chunked = chunks || compression || compression_opts || shuffle || fletcher32
        return unless chunked || !fillvalue.nil?
        raise HDF5::Error, 'Chunked storage is not supported for scalar datasets' if chunked && shape.empty?
        if dtype_object.nil? && !fillvalue.nil?
          raise UnsupportedFeatureError,
                'fillvalue is not supported for string datasets'
        end
        raise HDF5::Error, 'Unsupported compression' unless compression.nil? || compression == :gzip
        raise HDF5::Error, 'compression_opts requires compression: :gzip' if compression_opts && compression != :gzip

        itemsize = dtype_object ? dtype_object.itemsize : ::FFI.type_size(:pointer)
        if chunked
          chunk_shape = if chunks == :auto || chunks.nil?
                          auto_chunk_shape(shape,
                                           itemsize)
                        else
                          validate_chunk_shape(chunks,
                                               shape)
                        end
        end
        compression_level = compression_opts || 4
        unless compression.nil? || compression_level.between?(
          0, 9
        )
          raise HDF5::Error,
                'gzip compression_opts must be between 0 and 9'
        end

        validate_filter_available(1, 'gzip', capability: 1) if compression == :gzip
        validate_filter_available(2, 'shuffle', capability: 1) if shuffle
        validate_filter_available(3, 'Fletcher32', capability: 1) if fletcher32

        dcpl_id = HDF5::FFI.H5Pcreate(HDF5::FFI.H5P_CLS_DATASET_CREATE_ID_g)
        raise HDF5::Error, 'Failed to create dataset property list' if dcpl_id < 0

        if chunked
          dims = ::FFI::MemoryPointer.new(:ulong_long, chunk_shape.length)
          dims.write_array_of_ulong_long(chunk_shape)
          check_property_status(HDF5::FFI.H5Pset_chunk(dcpl_id, chunk_shape.length, dims), 'set chunk dimensions')
        end
        check_property_status(HDF5::FFI.H5Pset_shuffle(dcpl_id), 'enable shuffle') if shuffle
        if compression == :gzip
          check_property_status(HDF5::FFI.H5Pset_deflate(dcpl_id, compression_level),
                                'enable gzip')
        end
        check_property_status(HDF5::FFI.H5Pset_fletcher32(dcpl_id), 'enable Fletcher32') if fletcher32
        unless fillvalue.nil?
          value = dtype_object.numo_class.cast(fillvalue)
          raise HDF5::Error, 'fillvalue must be scalar' unless value.shape.empty?

          check_property_status(HDF5::FFI.H5Pset_fill_value(dcpl_id, dtype_object.memory_type_id, HDF5::DataHelpers.buffer_for(value)),
                                'set fill value')
        end
        dcpl_id
      rescue StandardError
        HDF5::FFI.H5Pclose(dcpl_id) if dcpl_id && dcpl_id >= 0
        raise
      end

      def auto_chunk_shape(shape, itemsize)
        target_bytes = 256 * 1024
        chunk_shape = shape.map { |dimension| [dimension, 1].max }

        while chunk_shape.inject(itemsize, :*) > target_bytes
          axis = chunk_shape.each_index.max_by { |index| chunk_shape[index] }
          chunk_shape[axis] = (chunk_shape[axis] / 2.0).ceil
        end

        chunk_shape
      end

      def validate_chunk_shape(chunks, shape)
        unless chunks.is_a?(Array) && chunks.length == shape.length
          raise HDF5::Error,
                'chunks must be an Array matching dataset rank'
        end
        unless chunks.all? { |dimension| dimension.is_a?(Integer) && dimension.positive? }
          raise HDF5::Error, 'chunk dimensions must be positive integers'
        end

        chunks
      end

      def check_property_status(status, operation)
        raise HDF5::Error, "Failed to #{operation}" if status < 0
      end

      def validate_filter_available(filter_id, name, capability:)
        unless HDF5::FFI.H5Zfilter_avail(filter_id).positive?
          raise UnsupportedFeatureError, "HDF5 #{name} filter is unavailable"
        end

        flags = ::FFI::MemoryPointer.new(:uint)
        status = HDF5::FFI.H5Zget_filter_info(filter_id, flags)
        raise HDF5::Error, "Failed to inspect HDF5 #{name} filter" if status < 0
        raise UnsupportedFeatureError, "HDF5 #{name} filter cannot encode data" if (flags.read_uint & capability).zero?
      end

      def from_id(dataset_id, name, context)
        dataset = allocate
        dataset.send(:initialize_from_id, dataset_id, name, context)
        dataset
      end
    end

    def initialize(parent_id, name)
      initialize_from_id(HDF5::FFI.H5Dopen2(parent_id, name, HDF5::DEFAULT_PROPERTY_LIST), name, nil)
    end

    def attrs
      ensure_open!
      @attrs ||= AttributeManager.new(@dataset_id, @context)
    end

    def write(data, selection: nil, casting: :safe)
      ensure_open!
      return write_string(data, selection:) if HDF5::StringCodec.string_data?(data)

      normalized_selection = Selection.normalize(selection, shape)
      values = if data.is_a?(Numeric)
                 target_dtype = dtype
                 if normalized_selection.scalar?
                   target_dtype.numo_class.cast(data)
                 else
                   target_dtype.numo_class.ones(*normalized_selection.result_shape) * data
                 end
               else
                 HDF5::DataHelpers.normalize_data(data, label: 'Dataset data')
               end
      raise HDF5::Error, 'Dataset shape must match data shape' unless values.shape == normalized_selection.result_shape

      dtype_object = DType.for_numo(values)
      target_dtype = dtype
      raise ConversionError, "Cannot safely cast #{dtype_object.to_sym} to #{target_dtype.to_sym}" unless
        dtype_object.castable_to?(target_dtype, casting:)
      return data if normalized_selection.size.zero?

      buffer = HDF5::DataHelpers.buffer_for(values)
      file_space_id = HDF5::FFI.H5Dget_space(@dataset_id)
      raise HDF5::Error, 'Failed to get dataset dataspace' if file_space_id < 0

      select_hyperslab(file_space_id, normalized_selection)
      memory_space_id = create_memory_dataspace(normalized_selection.result_shape)
      raise HDF5::Error, 'Failed to create memory dataspace' if memory_space_id < 0
      raise HDF5::Error, 'File and memory selections have different sizes' unless
        HDF5::FFI.H5Sget_select_npoints(file_space_id) == HDF5::FFI.H5Sget_select_npoints(memory_space_id)

      status = HDF5::FFI.H5Dwrite(@dataset_id, dtype_object.memory_type_id, memory_space_id, file_space_id,
                                  HDF5::DEFAULT_PROPERTY_LIST, buffer)
      raise HDF5::Error, 'Failed to write dataset' if status < 0

      data
    ensure
      HDF5::FFI.H5Sclose(memory_space_id) if memory_space_id && memory_space_id >= 0
      HDF5::FFI.H5Sclose(file_space_id) if file_space_id && file_space_id >= 0
    end

    def close
      return if @dataset_id.nil?

      @context ? @context.close(@dataset_id) : HDF5::FFI.H5Dclose(@dataset_id)
      @dataset_id = nil
    end

    def closed?
      @dataset_id.nil? || (@context && @context.closed?)
    end

    def dtype
      ensure_open!
      datatype_id = HDF5::FFI.H5Dget_type(@dataset_id)
      raise HDF5::Error, 'Failed to get datatype' if datatype_id < 0

      DType.for_hdf5(datatype_id)
    ensure
      HDF5::FFI.H5Tclose(datatype_id) if datatype_id && datatype_id >= 0
    end

    def shape
      ensure_open!
      dataspace_id = HDF5::FFI.H5Dget_space(@dataset_id)
      raise HDF5::Error, 'Failed to get dataspace' if dataspace_id < 0
      return nil if HDF5::FFI.H5Sget_simple_extent_type(dataspace_id) == :H5S_NULL

      ndims = HDF5::FFI.H5Sget_simple_extent_ndims(dataspace_id)
      raise HDF5::Error, 'Failed to get number of dimensions' if ndims < 0

      dims = ::FFI::MemoryPointer.new(:ulong_long, ndims)
      HDF5::FFI.H5Sget_simple_extent_dims(dataspace_id, dims, nil)

      dims.read_array_of_uint64(ndims)
    ensure
      HDF5::FFI.H5Sclose(dataspace_id) if dataspace_id && dataspace_id >= 0
    end

    def ndim
      shape&.length
    end

    def size
      shape&.inject(1, :*) || 0
    end

    def chunks
      ensure_open!
      property_list_id = HDF5::FFI.H5Dget_create_plist(@dataset_id)
      raise HDF5::Error, 'Failed to get dataset creation properties' if property_list_id < 0
      return nil unless HDF5::FFI.H5Pget_layout(property_list_id) == :H5D_CHUNKED

      dimensions = ::FFI::MemoryPointer.new(:ulong_long, shape.length)
      rank = HDF5::FFI.H5Pget_chunk(property_list_id, shape.length, dimensions)
      raise HDF5::Error, 'Failed to get chunk dimensions' if rank < 0

      dimensions.read_array_of_uint64(rank)
    ensure
      HDF5::FFI.H5Pclose(property_list_id) if property_list_id && property_list_id >= 0
    end

    def maxshape
      ensure_open!
      dataspace_id = HDF5::FFI.H5Dget_space(@dataset_id)
      raise HDF5::Error, 'Failed to get dataset dataspace' if dataspace_id < 0

      rank = HDF5::FFI.H5Sget_simple_extent_ndims(dataspace_id)
      return [] if rank.zero?

      maximums = ::FFI::MemoryPointer.new(:ulong_long, rank)
      status = HDF5::FFI.H5Sget_simple_extent_dims(dataspace_id, nil, maximums)
      raise HDF5::Error, 'Failed to get dataset maximum shape' if status < 0

      unlimited = (1 << (::FFI.type_size(:ulong_long) * 8)) - 1
      maximums.read_array_of_uint64(rank).map { |dimension| dimension == unlimited ? nil : dimension }
    ensure
      HDF5::FFI.H5Sclose(dataspace_id) if dataspace_id && dataspace_id >= 0
    end

    def fillvalue
      ensure_open!
      dtype_object = dtype
      property_list_id = HDF5::FFI.H5Dget_create_plist(@dataset_id)
      raise HDF5::Error, 'Failed to get dataset creation properties' if property_list_id < 0

      buffer = ::FFI::MemoryPointer.new(:char, dtype_object.itemsize)
      status = HDF5::FFI.H5Pget_fill_value(property_list_id, dtype_object.memory_type_id, buffer)
      raise HDF5::Error, 'Failed to get dataset fill value' if status < 0

      dtype_object.numo_class.from_binary(buffer.read_bytes(dtype_object.itemsize), []).extract
    ensure
      HDF5::FFI.H5Pclose(property_list_id) if property_list_id && property_list_id >= 0
    end

    def resize(new_shape)
      ensure_open!
      raise HDF5::Error, 'Cannot resize a Null dataset' if shape.nil?
      unless new_shape.is_a?(Array) && new_shape.length == shape.length
        raise HDF5::Error,
              'Dataset shape must be an Array matching dataset rank'
      end
      unless new_shape.all? { |dimension| dimension.is_a?(Integer) && dimension >= 0 }
        raise HDF5::Error, 'Dataset dimensions must be non-negative integers'
      end

      maxshape.zip(new_shape).each do |maximum, dimension|
        raise HDF5::Error, 'Dataset shape exceeds maxshape' if maximum && dimension > maximum
      end

      dimensions = ::FFI::MemoryPointer.new(:ulong_long, new_shape.length)
      dimensions.write_array_of_ulong_long(new_shape)
      status = HDF5::FFI.H5Dset_extent(@dataset_id, dimensions)
      raise HDF5::Error, 'Failed to resize dataset' if status < 0

      self
    end

    def append(data, axis: 0)
      ensure_open!
      values = HDF5::DataHelpers.normalize_data(data, label: 'Dataset data')
      current_shape = shape
      raise HDF5::Error, 'Cannot append to a Null dataset' if current_shape.nil?
      raise HDF5::Error, 'Cannot append to a scalar dataset' if current_shape.empty?
      raise IndexError, "Invalid append axis: #{axis}" unless axis.is_a?(Integer) && axis.between?(0,
                                                                                                   current_shape.length - 1)
      raise HDF5::Error, 'Appended data rank must match dataset rank' unless values.shape.length == current_shape.length
      raise HDF5::Error, 'Appended data shape must match all non-appended dimensions' unless
        values.shape.each_with_index.all? { |dimension, index| index == axis || dimension == current_shape[index] }

      source_dtype = DType.for_numo(values)
      target_dtype = dtype
      raise ConversionError, "Cannot safely cast #{source_dtype.to_sym} to #{target_dtype.to_sym}" unless
        source_dtype.castable_to?(target_dtype)
      return self if values.shape[axis].zero?

      new_shape = current_shape.dup
      new_shape[axis] += values.shape[axis]
      resize(new_shape)
      selection = current_shape.each_with_index.map do |dimension, index|
        index == axis ? dimension...new_shape[index] : 0...dimension
      end
      write(values, selection: selection)
      self
    rescue StandardError => e
      raise unless current_shape && new_shape && shape == new_shape

      begin
        resize(current_shape)
      rescue StandardError => rollback_error
        raise HDF5::Error,
              "Append failed (#{e.message}) and extent rollback failed (#{rollback_error.message}); current shape: #{shape.inspect}"
      end
      raise e
    end

    def read(selection: nil, dtype: nil, casting: :safe)
      ensure_open!
      type_id = HDF5::FFI.H5Dget_type(@dataset_id)
      raise HDF5::Error, 'Failed to get dataset datatype' if type_id < 0
      if dtype && HDF5::FFI.H5Tget_class(type_id) == :H5T_STRING
        raise ConversionError,
              'dtype is not supported for string datasets'
      end
      return read_string(type_id, selection:) if HDF5::FFI.H5Tget_class(type_id) == :H5T_STRING

      source_dtype = DType.for_hdf5(type_id)
      current_dtype = dtype ? DType.for_symbol(dtype) : source_dtype
      raise ConversionError, "Cannot safely cast #{source_dtype.to_sym} to #{current_dtype.to_sym}" unless
        source_dtype.castable_to?(current_dtype, casting:)

      current_shape = shape
      return HDF5::Empty.new(current_dtype) if current_shape.nil?

      normalized_selection = Selection.normalize(selection, current_shape)
      return current_dtype.numo_class.zeros(*normalized_selection.result_shape) if normalized_selection.size.zero?

      file_space_id = HDF5::FFI.H5Dget_space(@dataset_id)
      raise HDF5::Error, 'Failed to get dataset dataspace' if file_space_id < 0

      select_hyperslab(file_space_id, normalized_selection)
      memory_space_id = create_memory_dataspace(normalized_selection.result_shape)
      raise HDF5::Error, 'Failed to create memory dataspace' if memory_space_id < 0
      raise HDF5::Error, 'File and memory selections have different sizes' unless
        HDF5::FFI.H5Sget_select_npoints(file_space_id) == HDF5::FFI.H5Sget_select_npoints(memory_space_id)

      bytesize = normalized_selection.size * current_dtype.itemsize
      buffer = ::FFI::MemoryPointer.new(:char, bytesize)
      status = HDF5::FFI.H5Dread(@dataset_id, current_dtype.memory_type_id, memory_space_id, file_space_id,
                                 HDF5::DEFAULT_PROPERTY_LIST, buffer)
      raise HDF5::Error, 'Failed to read dataset' if status < 0

      result = HDF5::DataHelpers.from_binary(current_dtype, buffer.read_bytes(bytesize),
                                             normalized_selection.result_shape)
      return result unless normalized_selection.scalar?

      scalar = result.extract
      current_dtype.kind == :bool ? !scalar.zero? : scalar
    ensure
      HDF5::FFI.H5Tclose(type_id) if type_id && type_id >= 0
      HDF5::FFI.H5Sclose(memory_space_id) if memory_space_id && memory_space_id >= 0
      HDF5::FFI.H5Sclose(file_space_id) if file_space_id && file_space_id >= 0
    end

    def read_array(selection: nil, flatten: false, dtype: nil, casting: :safe)
      value = read(selection:, dtype:, casting:)
      return value unless value.is_a?(Numo::NArray)

      array = value.to_a
      flatten ? array.flatten : array
    end

    def [](*selection)
      read(selection: selection)
    end

    def []=(*selection, value)
      write(value, selection: selection)
    end

    def read_into(destination, selection: nil, casting: :safe)
      ensure_open!
      raise HDF5::Error, 'read_into destination must be a Numo::NArray' unless destination.is_a?(Numo::NArray)

      values = read(selection:, dtype: DType.for_numo(destination).to_sym, casting:)
      unless destination.shape == values.shape
        raise HDF5::Error,
              'read_into destination shape must match selection shape'
      end

      destination.store(values)
    end

    def each_block(max_bytes:)
      return enum_for(__method__, max_bytes:) unless block_given?

      ensure_open!
      raise ArgumentError, 'max_bytes must be a positive integer' unless max_bytes.is_a?(Integer) && max_bytes.positive?

      current_dtype = dtype
      raise ArgumentError, 'max_bytes is smaller than one dataset element' if max_bytes < current_dtype.itemsize

      current_shape = shape
      if current_shape.empty?
        yield [], read
        return
      end
      return if current_shape.any?(&:zero?)

      block_shape = block_shape_for(current_shape, max_bytes / current_dtype.itemsize)
      each_block_selection(current_shape, block_shape) do |selection|
        yield selection, read(selection: selection)
      end
    end

    def each_chunk
      return enum_for(__method__) unless block_given?

      ensure_open!

      chunk_shape = chunks
      raise HDF5::Error, 'each_chunk requires a chunked dataset' unless chunk_shape

      current_shape = shape
      return if current_shape.any?(&:zero?)

      each_block_selection(current_shape, chunk_shape) do |selection|
        yield selection, read(selection: selection)
      end
    end

    private

    def write_string(data, selection:)
      normalized_selection = Selection.normalize(selection, shape)
      values, values_shape = HDF5::StringCodec.normalize_data(data)
      unless values_shape == normalized_selection.result_shape
        raise HDF5::ShapeError,
              'Dataset shape must match string data shape'
      end
      return data if normalized_selection.size.zero?

      type_id = HDF5::FFI.H5Dget_type(@dataset_id)
      raise HDF5::Error, 'Failed to get dataset datatype' if type_id < 0
      unless HDF5::StringCodec.variable?(type_id)
        raise UnsupportedTypeError, 'Fixed-length string datasets are not yet supported'
      end

      file_space_id = HDF5::FFI.H5Dget_space(@dataset_id)
      select_hyperslab(file_space_id, normalized_selection)
      memory_space_id = create_memory_dataspace(normalized_selection.result_shape)
      buffer, _string_pointers = HDF5::StringCodec.buffer_for_values(values)
      status = HDF5::FFI.H5Dwrite(@dataset_id, type_id, memory_space_id, file_space_id,
                                  HDF5::DEFAULT_PROPERTY_LIST, buffer)
      raise HDF5::Error, 'Failed to write string dataset' if status < 0

      data
    ensure
      HDF5::FFI.H5Tclose(type_id) if type_id && type_id >= 0
      HDF5::FFI.H5Sclose(memory_space_id) if memory_space_id && memory_space_id >= 0
      HDF5::FFI.H5Sclose(file_space_id) if file_space_id && file_space_id >= 0
    end

    def read_string(type_id, selection:)
      normalized_selection = Selection.normalize(selection, shape)
      unless HDF5::StringCodec.variable?(type_id)
        raise UnsupportedTypeError, 'Fixed-length string datasets are not yet supported'
      end
      return Numo::RObject.new(*normalized_selection.result_shape) if normalized_selection.size.zero?

      file_space_id = HDF5::FFI.H5Dget_space(@dataset_id)
      select_hyperslab(file_space_id, normalized_selection)
      memory_space_id = create_memory_dataspace(normalized_selection.result_shape)
      buffer = ::FFI::MemoryPointer.new(:pointer, normalized_selection.size)
      status = HDF5::FFI.H5Dread(@dataset_id, type_id, memory_space_id, file_space_id,
                                 HDF5::DEFAULT_PROPERTY_LIST, buffer)
      raise HDF5::Error, 'Failed to read string dataset' if status < 0

      HDF5::StringCodec.read_values(buffer, normalized_selection.size, normalized_selection.result_shape)
    ensure
      if buffer && type_id && memory_space_id
        active_error = $ERROR_INFO
        reclaim_status = HDF5::FFI.H5Dvlen_reclaim(type_id, memory_space_id, HDF5::DEFAULT_PROPERTY_LIST, buffer)
        if reclaim_status.negative? && active_error.nil?
          raise HDF5::Error,
                'Failed to reclaim variable-length string data'
        end
      end
      HDF5::FFI.H5Sclose(memory_space_id) if memory_space_id && memory_space_id >= 0
      HDF5::FFI.H5Sclose(file_space_id) if file_space_id && file_space_id >= 0
    end

    def block_shape_for(dataset_shape, max_elements)
      remaining = max_elements
      dataset_shape.reverse.map do |dimension|
        block_dimension = [dimension, remaining].min
        remaining /= block_dimension
        block_dimension
      end.reverse
    end

    def each_block_selection(dataset_shape, block_shape, axis = 0, prefix = [], &block)
      if axis == dataset_shape.length
        yield prefix
        return
      end

      0.step(dataset_shape[axis] - 1, block_shape[axis]) do |start|
        length = [block_shape[axis], dataset_shape[axis] - start].min
        each_block_selection(dataset_shape, block_shape, axis + 1, prefix + [start...(start + length)], &block)
      end
    end

    def create_memory_dataspace(shape)
      return HDF5::FFI.H5Screate(:H5S_SCALAR) if shape.empty?

      dims = ::FFI::MemoryPointer.new(:ulong_long, shape.length)
      dims.write_array_of_ulong_long(shape)
      HDF5::FFI.H5Screate_simple(shape.length, dims, nil)
    end

    def select_hyperslab(dataspace_id, selection)
      rank = selection.start.length
      return if rank.zero?

      start = ::FFI::MemoryPointer.new(:ulong_long, rank)
      stride = ::FFI::MemoryPointer.new(:ulong_long, rank)
      count = ::FFI::MemoryPointer.new(:ulong_long, rank)
      start.write_array_of_ulong_long(selection.start)
      stride.write_array_of_ulong_long(selection.stride)
      count.write_array_of_ulong_long(selection.count)
      status = HDF5::FFI.H5Sselect_hyperslab(dataspace_id, :H5S_SELECT_SET, start, stride, count, nil)
      raise HDF5::Error, 'Failed to select dataset region' if status < 0
    end

    def initialize_from_id(dataset_id, name, context)
      raise HDF5::Error, "Failed to open dataset: #{name}" if dataset_id < 0

      @dataset_id = dataset_id
      @name = name
      @context = context
      @context.register(dataset_id, :dataset) if @context
    end

    def ensure_open!
      raise ClosedError, 'HDF5 dataset is closed' if @dataset_id.nil?

      @context&.ensure_open!(@dataset_id)
    end

    prepend FileContext.guard(
      :attrs, :write, :dtype, :shape, :chunks, :maxshape, :fillvalue, :resize, :append, :read, :read_array,
      :[], :[]=, :read_into, :each_block, :each_chunk
    )
  end
end
