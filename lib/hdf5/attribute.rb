require 'securerandom'

module HDF5
  class Attribute
    def initialize(dataset_id, attr_name, context = nil)
      @dataset_id = dataset_id
      @attr_name = attr_name
      context&.ensure_open!(dataset_id)
      @attr_id = HDF5::FFI.H5Aopen(@dataset_id, @attr_name, HDF5::DEFAULT_PROPERTY_LIST)
      raise HDF5::Error, 'Failed to open attribute' if @attr_id < 0
    end

    def read
      type_id = HDF5::FFI.H5Aget_type(@attr_id)
      raise HDF5::Error, 'Failed to get attribute datatype' if type_id < 0

      space_id = HDF5::FFI.H5Aget_space(@attr_id)
      raise HDF5::Error, 'Failed to get attribute dataspace' if space_id < 0
      return HDF5::Empty.new(DType.for_hdf5(type_id)) if HDF5::FFI.H5Sget_simple_extent_type(space_id) == :H5S_NULL

      return read_string(type_id, space_id) if HDF5::FFI.H5Tget_class(type_id) == :H5T_STRING

      dtype_object = DType.for_hdf5(type_id)
      attribute_shape = shape(space_id)
      size = attribute_shape.empty? ? 1 : attribute_shape.inject(:*)
      buffer = ::FFI::MemoryPointer.new(:char, size * dtype_object.itemsize)
      status = HDF5::FFI.H5Aread(@attr_id, dtype_object.memory_type_id, buffer)
      raise HDF5::Error, 'Failed to read attribute' if status < 0

      result = HDF5::DataHelpers.from_binary(dtype_object, buffer.read_bytes(size * dtype_object.itemsize),
                                             attribute_shape)
      return result unless attribute_shape.empty?

      scalar = result.extract
      dtype_object.kind == :bool ? !scalar.zero? : scalar
    ensure
      HDF5::FFI.H5Tclose(type_id) if type_id && type_id >= 0
      HDF5::FFI.H5Sclose(space_id) if space_id && space_id >= 0
    end

    def close
      return if @attr_id.nil?

      HDF5::FFI.H5Aclose(@attr_id)
      @attr_id = nil
    end

    private

    def shape(space_id)
      rank = HDF5::FFI.H5Sget_simple_extent_ndims(space_id)
      raise HDF5::Error, 'Failed to get attribute rank' if rank < 0
      return [] if rank.zero?

      dimensions = ::FFI::MemoryPointer.new(:ulong_long, rank)
      status = HDF5::FFI.H5Sget_simple_extent_dims(space_id, dimensions, nil)
      raise HDF5::Error, 'Failed to get attribute shape' if status < 0

      dimensions.read_array_of_uint64(rank)
    end

    def read_string(type_id, space_id)
      unless HDF5::StringCodec.variable?(type_id)
        raise UnsupportedTypeError, 'Fixed-length string attributes are not yet supported'
      end

      attribute_shape = shape(space_id)
      count = attribute_shape.empty? ? 1 : attribute_shape.inject(:*)
      return Numo::RObject.new(*attribute_shape) if count.zero?

      buffer = ::FFI::MemoryPointer.new(:pointer, count)
      status = HDF5::FFI.H5Aread(@attr_id, type_id, buffer)
      raise HDF5::Error, 'Failed to read string attribute' if status < 0

      HDF5::StringCodec.read_values(buffer, count, attribute_shape, encoding: HDF5::StringCodec.encoding_for(type_id))
    ensure
      if buffer
        active_error = $ERROR_INFO
        reclaim_status = HDF5::FFI.H5Dvlen_reclaim(type_id, space_id, HDF5::DEFAULT_PROPERTY_LIST, buffer)
        if reclaim_status.negative? && active_error.nil?
          raise HDF5::Error,
                'Failed to reclaim variable-length string attribute'
        end
      end
    end
  end

  class AttributeManager
    def initialize(dataset_id, context = nil)
      @dataset_id = dataset_id
      @context = context
    end

    def [](attr_name)
      @context&.ensure_open!(@dataset_id)
      attr = Attribute.new(@dataset_id, attr_name, @context)
      attr.read
    ensure
      attr.close if attr
    end

    def []=(attr_name, value)
      write(attr_name, value)
    end

    def keys
      @context&.ensure_open!(@dataset_id)
      names = []
      index = ::FFI::MemoryPointer.new(:ulong_long)
      index.write_ulong_long(0)
      callback = ::FFI::Function.new(:int, %i[int64_t string pointer pointer]) do |_, name, _, _|
        names << name
        0
      end
      status = HDF5::FFI.H5Aiterate2(@dataset_id, :H5_INDEX_NAME, :H5_ITER_NATIVE, index, callback, nil)
      raise HDF5::Error, 'Failed to iterate over attributes' if status < 0

      names
    end

    def key?(attr_name)
      @context&.ensure_open!(@dataset_id)
      exists = HDF5::FFI.H5Aexists(@dataset_id, attr_name)
      raise HDF5::Error, "Failed to check attribute existence: #{attr_name}" if exists.negative?

      exists.positive?
    end

    def delete(attr_name)
      @context&.ensure_open!(@dataset_id)
      status = HDF5::FFI.H5Adelete(@dataset_id, attr_name)
      raise HDF5::Error, "Failed to delete attribute: #{attr_name}" if status < 0

      self
    end

    def create(attr_name, value, dtype: nil, casting: :safe)
      raise HDF5::Error, "Attribute already exists: #{attr_name}" if key?(attr_name)

      write(attr_name, value, dtype:, casting:)
    end

    def modify(attr_name, value, casting: :safe)
      @context&.ensure_open!(@dataset_id)
      raise HDF5::Error, "Attribute not found: #{attr_name}" unless key?(attr_name)

      attr_id = HDF5::FFI.H5Aopen(@dataset_id, attr_name, HDF5::DEFAULT_PROPERTY_LIST)
      raise HDF5::Error, "Failed to open attribute: #{attr_name}" if attr_id < 0

      type_id = HDF5::FFI.H5Aget_type(attr_id)
      space_id = HDF5::FFI.H5Aget_space(attr_id)
      raise HDF5::Error, "Failed to inspect attribute: #{attr_name}" if type_id < 0 || space_id < 0
      if HDF5::FFI.H5Sget_simple_extent_type(space_id) == :H5S_NULL
        unless value.is_a?(HDF5::Empty) && value.dtype.to_sym == DType.for_hdf5(type_id).to_sym
          raise HDF5::ShapeError, 'Cannot assign a value to a Null attribute'
        end
        return value
      end

      if HDF5::FFI.H5Tget_class(type_id) == :H5T_STRING
        unless HDF5::StringCodec.variable?(type_id)
          raise UnsupportedTypeError, 'Fixed-length string attributes are not yet supported'
        end

        encoding = HDF5::StringCodec.encoding_for(type_id)
        string_values, string_shape = HDF5::StringCodec.normalize_data(value, encoding:)
        unless string_shape == attribute_shape(space_id)
          raise HDF5::ShapeError,
                'Attribute shape must not change when modifying'
        end

        buffer, _string_pointers = HDF5::StringCodec.buffer_for_values(string_values, encoding:)
        status = HDF5::FFI.H5Awrite(attr_id, type_id, buffer)
      else
        dtype_object = DType.for_hdf5(type_id)
        values = HDF5::DataHelpers.normalize_data(value, label: 'Attribute data', dtype: dtype_object, casting:, convert: false)
        expected_shape = attribute_shape(space_id)
        raise HDF5::Error, 'Attribute shape must not change when modifying' unless values.shape == expected_shape

        status = HDF5::FFI.H5Awrite(attr_id, DType.for_numo(values).memory_type_id, HDF5::DataHelpers.buffer_for(values))
      end
      raise HDF5::Error, "Failed to modify attribute: #{attr_name}" if status < 0

      value
    ensure
      HDF5::FFI.H5Sclose(space_id) if space_id && space_id >= 0
      HDF5::FFI.H5Tclose(type_id) if type_id && type_id >= 0
      HDF5::FFI.H5Aclose(attr_id) if attr_id && attr_id >= 0
    end

    def write(attr_name, value, dtype: nil, casting: :safe)
      @context&.ensure_open!(@dataset_id)
      raise ArgumentError, "Unsupported casting mode: #{casting.inspect}" unless %i[safe unsafe].include?(casting)

      empty_data = value.is_a?(HDF5::Empty)
      explicit_dtype = DType.for_symbol(dtype) if dtype
      if empty_data && explicit_dtype && explicit_dtype.to_sym != value.dtype.to_sym
        raise ConversionError, 'dtype must match the Null attribute dtype'
      end
      inferred_string = HDF5::StringCodec.string_data?(value)
      if inferred_string && explicit_dtype && explicit_dtype.kind != :string
        raise ConversionError, 'Cannot create a numeric attribute from string data'
      end
      string_type = inferred_string || explicit_dtype&.kind == :string || empty_data && value.dtype.kind == :string
      string_data = string_type && !empty_data
      string_values, string_shape = HDF5::StringCodec.normalize_data(value) if string_data
      values = HDF5::DataHelpers.normalize_data(value, label: 'Attribute data', dtype: explicit_dtype, casting:) unless string_type || empty_data
      dtype_object = empty_data ? value.dtype : (explicit_dtype || DType.for_numo(values)) unless string_type
      type_id = string_type ? HDF5::StringCodec.datatype_id : dtype_object.storage_type_id

      exists = HDF5::FFI.H5Aexists(@dataset_id, attr_name)
      raise HDF5::Error, "Failed to check attribute existence: #{attr_name}" if exists.negative?

      # Write a replacement completely before changing the existing attribute.
      written_name = exists.positive? ? temporary_attribute_name : attr_name

      dataspace_id = create_dataspace(empty_data ? nil : (string_data ? string_shape : values.shape))
      raise HDF5::Error, 'Failed to create attribute dataspace' if dataspace_id < 0

      attr_id = HDF5::FFI.H5Acreate2(
        @dataset_id,
        written_name,
        type_id,
        dataspace_id,
        HDF5::DEFAULT_PROPERTY_LIST,
        HDF5::DEFAULT_PROPERTY_LIST
      )
      raise HDF5::Error, "Failed to create attribute: #{attr_name}" if attr_id < 0
      created = true

      unless empty_data || string_data && string_values.empty?
        buffer, _string_pointers = if string_data
                                     HDF5::StringCodec.buffer_for_values(string_values)
                                   else
                                     [HDF5::DataHelpers.buffer_for(values), nil]
                                   end
        memory_type_id = string_data ? type_id : dtype_object.memory_type_id
        status = HDF5::FFI.H5Awrite(attr_id, memory_type_id, buffer)
        raise HDF5::Error, "Failed to write attribute: #{attr_name}" if status < 0
      end

      replace_attribute(attr_name, written_name) if exists.positive?
      initialized = true

      value
    ensure
      HDF5::FFI.H5Aclose(attr_id) if attr_id && attr_id >= 0
      if created && !initialized && HDF5::FFI.H5Aexists(@dataset_id, written_name).positive?
        HDF5::FFI.H5Adelete(@dataset_id, written_name)
      end
      HDF5::FFI.H5Sclose(dataspace_id) if dataspace_id && dataspace_id >= 0
      HDF5::FFI.H5Tclose(type_id) if string_type && type_id && type_id >= 0
    end

    private

    def temporary_attribute_name
      loop do
        name = ".ruby-hdf5-#{SecureRandom.hex(16)}"
        return name unless key?(name)
      end
    end

    def replace_attribute(attr_name, written_name)
      backup_name = temporary_attribute_name
      if HDF5::FFI.H5Arename(@dataset_id, attr_name, backup_name).negative?
        raise HDF5::Error, "Failed to back up attribute: #{attr_name}"
      end

      if HDF5::FFI.H5Arename(@dataset_id, written_name, attr_name).negative?
        if HDF5::FFI.H5Arename(@dataset_id, backup_name, attr_name).negative?
          raise HDF5::Error, "Failed to replace attribute: #{attr_name}; original retained as #{backup_name}"
        end
        raise HDF5::Error, "Failed to replace attribute: #{attr_name}"
      end

      if HDF5::FFI.H5Adelete(@dataset_id, backup_name).negative?
        raise HDF5::Error, "Failed to remove attribute backup: #{backup_name}"
      end
    end

    def attribute_shape(space_id)
      rank = HDF5::FFI.H5Sget_simple_extent_ndims(space_id)
      raise HDF5::Error, 'Failed to get attribute rank' if rank < 0
      return [] if rank.zero?

      dimensions = ::FFI::MemoryPointer.new(:ulong_long, rank)
      status = HDF5::FFI.H5Sget_simple_extent_dims(space_id, dimensions, nil)
      raise HDF5::Error, 'Failed to get attribute shape' if status < 0

      dimensions.read_array_of_uint64(rank)
    end

    def create_dataspace(shape)
      return HDF5::FFI.H5Screate(:H5S_NULL) if shape.nil?

      return HDF5::FFI.H5Screate(:H5S_SCALAR) if shape.empty?

      dimensions = ::FFI::MemoryPointer.new(:ulong_long, shape.length)
      dimensions.write_array_of_ulong_long(shape)
      HDF5::FFI.H5Screate_simple(shape.length, dimensions, nil)
    end

    prepend FileContext.guard(:[], :[]=, :keys, :key?, :delete, :create, :modify, :write)
  end
end
