module HDF5
  class Dataset
    module DataHelpers
      module_function

      def normalize_data(data)
        return data if data.is_a?(Numo::NArray) && DType.for_numo(data)

        values = data.is_a?(Array) ? data.flatten : [data]
        raise HDF5::Error, 'Dataset data must not be empty' if values.empty?

        dtype = if values.all? { |value| value.is_a?(Integer) }
                  DType.for_symbol(:int64)
                elsif values.all? { |value| value.is_a?(Numeric) }
                  DType.for_symbol(:float64)
                else
                  raise HDF5::Error, 'Only numeric dataset data is supported'
                end
        dtype.numo_class.cast(data)
      end

      def buffer_for(narray)
        binary = narray.to_binary
        expected_bytes = narray.size * DType.for_numo(narray).itemsize
        raise HDF5::Error, 'Numo binary representation has an unexpected size' unless binary.bytesize == expected_bytes

        ::FFI::MemoryPointer.new(:char, expected_bytes).tap { |buffer| buffer.put_bytes(0, binary) }
      end
    end

    private_constant :DataHelpers

    class << self
      def create(parent_id, name, data = nil, shape: nil, dtype: nil)
        narray = DataHelpers.normalize_data(data) unless data.nil?
        dtype_object = dtype ? DType.for_symbol(dtype) : DType.for_numo(narray)
        shape ||= narray.shape
        raise HDF5::Error, 'shape: and dtype: are required when data: is omitted' if data.nil? && (!shape || !dtype)
        raise HDF5::Error, 'Dataset shape must match data shape' if narray && shape != narray.shape

        dataspace_id = create_dataspace(shape)
        raise HDF5::Error, "Failed to create dataspace for dataset: #{name}" if dataspace_id < 0

        dataset = from_id(
          HDF5::FFI.H5Dcreate2(parent_id, name, dtype_object.storage_type_id, dataspace_id, HDF5::DEFAULT_PROPERTY_LIST,
                               HDF5::DEFAULT_PROPERTY_LIST, HDF5::DEFAULT_PROPERTY_LIST), name
        )
        dataset.write(narray) if narray
        return dataset unless block_given?

        begin
          yield dataset
        ensure
          dataset.close
        end
      ensure
        HDF5::FFI.H5Sclose(dataspace_id) if dataspace_id && dataspace_id >= 0
      end

      def open(parent_id, name)
        dataset = from_id(HDF5::FFI.H5Dopen2(parent_id, name, HDF5::DEFAULT_PROPERTY_LIST), name)
        return dataset unless block_given?

        begin
          yield dataset
        ensure
          dataset.close
        end
      end

      private

      def create_dataspace(shape)
        return HDF5::FFI.H5Screate(:H5S_SCALAR) if shape.empty?

        dims = ::FFI::MemoryPointer.new(:ulong_long, shape.length)
        dims.write_array_of_ulong_long(shape)
        HDF5::FFI.H5Screate_simple(shape.length, dims, nil)
      end

      def from_id(dataset_id, name)
        dataset = allocate
        dataset.send(:initialize_from_id, dataset_id, name)
        dataset
      end
    end

    def initialize(parent_id, name)
      initialize_from_id(HDF5::FFI.H5Dopen2(parent_id, name, HDF5::DEFAULT_PROPERTY_LIST), name)
    end

    def attrs
      @attrs ||= AttributeManager.new(@dataset_id)
    end

    def write(data, selection: nil)
      normalized_selection = Selection.normalize(selection, shape)
      values = if data.is_a?(Numeric)
                 target_dtype = dtype
                 normalized_selection.scalar? ? target_dtype.numo_class.cast(data) :
                   target_dtype.numo_class.ones(*normalized_selection.result_shape) * data
               else
                 DataHelpers.normalize_data(data)
               end
      raise HDF5::Error, 'Dataset shape must match data shape' unless values.shape == normalized_selection.result_shape

      dtype_object = DType.for_numo(values)
      buffer = DataHelpers.buffer_for(values)
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

      HDF5::FFI.H5Dclose(@dataset_id)
      @dataset_id = nil
    end

    def dtype
      datatype_id = HDF5::FFI.H5Dget_type(@dataset_id)
      raise HDF5::Error, 'Failed to get datatype' if datatype_id < 0

      DType.for_hdf5(datatype_id)
    ensure
      HDF5::FFI.H5Tclose(datatype_id) if datatype_id && datatype_id >= 0
    end

    def shape
      dataspace_id = HDF5::FFI.H5Dget_space(@dataset_id)
      raise HDF5::Error, 'Failed to get dataspace' if dataspace_id < 0

      ndims = HDF5::FFI.H5Sget_simple_extent_ndims(dataspace_id)
      raise HDF5::Error, 'Failed to get number of dimensions' if ndims < 0

      dims = ::FFI::MemoryPointer.new(:ulong_long, ndims)
      HDF5::FFI.H5Sget_simple_extent_dims(dataspace_id, dims, nil)

      dims.read_array_of_uint64(ndims)
    ensure
      HDF5::FFI.H5Sclose(dataspace_id) if dataspace_id && dataspace_id >= 0
    end

    def read(selection: nil)
      current_dtype = dtype
      current_shape = shape
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

      result = current_dtype.numo_class.from_binary(buffer.read_bytes(bytesize), normalized_selection.result_shape)
      normalized_selection.scalar? ? result.extract : result
    ensure
      HDF5::FFI.H5Sclose(memory_space_id) if memory_space_id && memory_space_id >= 0
      HDF5::FFI.H5Sclose(file_space_id) if file_space_id && file_space_id >= 0
    end

    def [](*selection)
      read(selection: selection)
    end

    def []=(*selection, value)
      write(value, selection: selection)
    end

    def read_into(destination, selection: nil)
      raise HDF5::Error, 'read_into destination must be a Numo::NArray' unless destination.is_a?(Numo::NArray)

      values = read(selection: selection)
      raise HDF5::Error, 'read_into destination shape must match selection shape' unless destination.shape == values.shape

      destination.store(values)
    end

    def each_block(max_bytes:)
      return enum_for(__method__, max_bytes:) unless block_given?
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

    private

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

    def initialize_from_id(dataset_id, name)
      raise HDF5::Error, "Failed to open dataset: #{name}" if dataset_id < 0

      @dataset_id = dataset_id
      @name = name
    end
  end
end
