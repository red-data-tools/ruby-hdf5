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

    def []=(attr_name, value)
      write(attr_name, value)
    end

    def write(attr_name, value)
      values = normalize_data(value)
      datatype_id = datatype_id_for(values)

      dims = ::FFI::MemoryPointer.new(:ulong_long, 1)
      dims.write_array_of_ulong_long([values.length])
      dataspace_id = HDF5::FFI.H5Screate_simple(1, dims, nil)
      raise HDF5::Error, 'Failed to create attribute dataspace' if dataspace_id < 0

      attr_id = HDF5::FFI.H5Acreate2(
        @dataset_id,
        attr_name,
        datatype_id,
        dataspace_id,
        HDF5::DEFAULT_PROPERTY_LIST,
        HDF5::DEFAULT_PROPERTY_LIST
      )
      raise HDF5::Error, "Failed to create attribute: #{attr_name}" if attr_id < 0

      buffer = buffer_for(values)
      status = HDF5::FFI.H5Awrite(attr_id, datatype_id, buffer)
      raise HDF5::Error, "Failed to write attribute: #{attr_name}" if status < 0

      value
    ensure
      HDF5::FFI.H5Aclose(attr_id) if attr_id && attr_id >= 0
      HDF5::FFI.H5Sclose(dataspace_id) if dataspace_id && dataspace_id >= 0
    end

    private

    def normalize_data(value)
      values = value.is_a?(Array) ? value : [value]
      raise HDF5::Error, 'Attribute data must not be empty' if values.empty?
      raise HDF5::Error, 'Nested arrays are not supported for attributes' if values.any? { |item| item.is_a?(Array) }

      values
    end

    def datatype_id_for(values)
      if values.all? { |item| item.is_a?(Integer) }
        HDF5::FFI.H5T_NATIVE_INT
      elsif values.all? { |item| item.is_a?(Numeric) }
        HDF5::FFI.H5T_NATIVE_DOUBLE
      else
        raise HDF5::Error, 'Only numeric attribute data is supported'
      end
    end

    def buffer_for(values)
      if values.all? { |item| item.is_a?(Integer) }
        buffer = ::FFI::MemoryPointer.new(:int, values.length)
        buffer.write_array_of_int(values)
      else
        buffer = ::FFI::MemoryPointer.new(:double, values.length)
        buffer.write_array_of_double(values.map(&:to_f))
      end

      buffer
    end
  end
end
