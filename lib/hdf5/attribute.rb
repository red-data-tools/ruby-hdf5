module HDF5
  class Attribute
    def initialize(dataset_id, attr_name)
      @dataset_id = dataset_id
      @attr_name = attr_name
      @attr_id = HDF5::FFI.H5Aopen(@dataset_id, @attr_name, HDF5::DEFAULT_PROPERTY_LIST)
      raise HDF5::Error, 'Failed to open attribute' if @attr_id < 0
    end

    def read
      type_id = HDF5::FFI.H5Aget_type(@attr_id)
      raise HDF5::Error, 'Failed to get attribute datatype' if type_id < 0
      space_id = HDF5::FFI.H5Aget_space(@attr_id)
      raise HDF5::Error, 'Failed to get attribute dataspace' if space_id < 0
      return read_string(type_id, space_id) if HDF5::FFI.H5Tget_class(type_id) == :H5T_STRING

      dtype_object = DType.for_hdf5(type_id)
      attribute_shape = shape(space_id)
      size = attribute_shape.empty? ? 1 : attribute_shape.inject(:*)
      buffer = ::FFI::MemoryPointer.new(:char, size * dtype_object.itemsize)
      status = HDF5::FFI.H5Aread(@attr_id, dtype_object.memory_type_id, buffer)
      raise HDF5::Error, 'Failed to read attribute' if status < 0

      result = dtype_object.numo_class.from_binary(buffer.read_bytes(size * dtype_object.itemsize), attribute_shape)
      attribute_shape.empty? ? result.extract : result
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
      buffer = ::FFI::MemoryPointer.new(:pointer)
      status = HDF5::FFI.H5Aread(@attr_id, type_id, buffer)
      raise HDF5::Error, 'Failed to read string attribute' if status < 0

      HDF5::StringCodec.read(buffer)
    ensure
      HDF5::FFI.H5Dvlen_reclaim(type_id, space_id, HDF5::DEFAULT_PROPERTY_LIST, buffer) if buffer
    end
  end

  class AttributeManager
    def initialize(dataset_id)
      @dataset_id = dataset_id
    end

    def [](attr_name)
      attr = Attribute.new(@dataset_id, attr_name)
      attr.read
    ensure
      attr.close if attr
    end

    def []=(attr_name, value)
      write(attr_name, value)
    end

    def write(attr_name, value)
      string_data = value.is_a?(String)
      values = HDF5::DataHelpers.normalize_data(value, label: 'Attribute data') unless string_data
      dtype_object = DType.for_numo(values) unless string_data
      type_id = string_data ? HDF5::StringCodec.datatype_id : dtype_object.storage_type_id

      exists = HDF5::FFI.H5Aexists(@dataset_id, attr_name)
      raise HDF5::Error, "Failed to check attribute existence: #{attr_name}" if exists.negative?

      if exists.positive?
        status = HDF5::FFI.H5Adelete(@dataset_id, attr_name)
        raise HDF5::Error, "Failed to replace attribute: #{attr_name}" if status < 0
      end

      dataspace_id = create_dataspace(string_data ? [] : values.shape)
      raise HDF5::Error, 'Failed to create attribute dataspace' if dataspace_id < 0

      attr_id = HDF5::FFI.H5Acreate2(
        @dataset_id,
        attr_name,
        type_id,
        dataspace_id,
        HDF5::DEFAULT_PROPERTY_LIST,
        HDF5::DEFAULT_PROPERTY_LIST
      )
      raise HDF5::Error, "Failed to create attribute: #{attr_name}" if attr_id < 0

      buffer, string_pointer = string_data ? HDF5::StringCodec.buffer_for(value) : [HDF5::DataHelpers.buffer_for(values), nil]
      memory_type_id = string_data ? type_id : dtype_object.memory_type_id
      status = HDF5::FFI.H5Awrite(attr_id, memory_type_id, buffer)
      raise HDF5::Error, "Failed to write attribute: #{attr_name}" if status < 0

      value
    ensure
      HDF5::FFI.H5Aclose(attr_id) if attr_id && attr_id >= 0
      HDF5::FFI.H5Sclose(dataspace_id) if dataspace_id && dataspace_id >= 0
      HDF5::FFI.H5Tclose(type_id) if string_data && type_id && type_id >= 0
    end

    private

    def create_dataspace(shape)
      return HDF5::FFI.H5Screate(:H5S_SCALAR) if shape.empty?

      dimensions = ::FFI::MemoryPointer.new(:ulong_long, shape.length)
      dimensions.write_array_of_ulong_long(shape)
      HDF5::FFI.H5Screate_simple(shape.length, dimensions, nil)
    end
  end
end
