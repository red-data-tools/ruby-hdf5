module HDF5
  class Attribute
    def initialize(dataset_id, attr_name)
      @dataset_id = dataset_id
      @attr_name = attr_name
      @attr_id = FFI.H5Aopen(@dataset_id, @attr_name, 0)
      raise 'Failed to open attribute' if @attr_id < 0
    end

    def read
      type_id = FFI.H5Aget_type(@attr_id)
      space_id = FFI.H5Aget_space(@attr_id)

      size = FFI.H5Sget_simple_extent_npoints(space_id)

      buffer = \
        case FFI.H5Tget_class(type_id)
        when :H5T_INTEGER
          ::FFI::MemoryPointer.new(:int, size)
        when :H5T_FLOAT
          ::FFI::MemoryPointer.new(:double, size)
        when :H5T_STRING
          ::FFI::MemoryPointer.new(:pointer, size)
        else
          raise 'Unsupported data type'
        end

      status = FFI.H5Aread(@attr_id, type_id, buffer)
      raise 'Failed to read attribute' if status < 0

      case FFI.H5Tget_class(type_id)
      when :H5T_INTEGER
        buffer.read_array_of_int(size)
      when :H5T_FLOAT
        buffer.read_array_of_double(size)
      when :H5T_STRING
        buffer.read_pointer.read_string
      else
        raise 'Unsupported data type'
      end
    end

    def close
      FFI.H5Aclose(@attr_id)
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
