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
      space_id = HDF5::FFI.H5Aget_space(@attr_id)

      size = HDF5::FFI.H5Sget_simple_extent_npoints(space_id)

      buffer = \
        case HDF5::FFI.H5Tget_class(type_id)
        when :H5T_INTEGER
          ::FFI::MemoryPointer.new(:int, size)
        when :H5T_FLOAT
          ::FFI::MemoryPointer.new(:double, size)
        when :H5T_STRING
          ::FFI::MemoryPointer.new(:pointer, size)
        else
          raise HDF5::Error, 'Unsupported data type'
        end

      status = HDF5::FFI.H5Aread(@attr_id, type_id, buffer)
      raise HDF5::Error, 'Failed to read attribute' if status < 0

      case HDF5::FFI.H5Tget_class(type_id)
      when :H5T_INTEGER
        buffer.read_array_of_int(size)
      when :H5T_FLOAT
        buffer.read_array_of_double(size)
      when :H5T_STRING
        buffer.read_pointer.read_string
      else
        raise HDF5::Error, 'Unsupported data type'
      end
    ensure
      HDF5::FFI.H5Tclose(type_id) if type_id && type_id >= 0
      HDF5::FFI.H5Sclose(space_id) if space_id && space_id >= 0
    end

    def close
      return if @attr_id.nil?

      HDF5::FFI.H5Aclose(@attr_id)
      @attr_id = nil
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
  end
end
