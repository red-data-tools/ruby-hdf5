module HDF5
  module StringCodec
    module_function

    UTF8 = 1
    VARIABLE_SIZE = (1 << (::FFI.type_size(:size_t) * 8)) - 1

    def datatype_id
      type_id = HDF5::FFI.H5Tcopy(HDF5::FFI.H5T_C_S1)
      raise HDF5::Error, 'Failed to create string datatype' if type_id < 0

      check(HDF5::FFI.H5Tset_size(type_id, VARIABLE_SIZE), 'set variable string size')
      check(HDF5::FFI.H5Tset_cset(type_id, UTF8), 'set UTF-8 string encoding')
      type_id
    rescue StandardError
      HDF5::FFI.H5Tclose(type_id) if type_id && type_id >= 0
      raise
    end

    def buffer_for(value)
      buffer_for_values([normalize(value)])
    end

    def buffer_for_values(values)
      pointers = values.map { |value| ::FFI::MemoryPointer.from_string(normalize(value)) }
      buffer = ::FFI::MemoryPointer.new(:pointer, pointers.length)
      buffer.write_array_of_pointer(pointers)
      [buffer, pointers]
    end

    def read(buffer)
      pointer = buffer.read_pointer
      pointer.null? ? nil : pointer.read_string.force_encoding(Encoding::UTF_8)
    end

    def read_values(buffer, count, shape)
      values = buffer.read_array_of_pointer(count).map do |pointer|
        pointer.null? ? nil : pointer.read_string.force_encoding(Encoding::UTF_8)
      end
      return values.first if shape.empty?

      Numo::RObject.cast(values).reshape(*shape)
    end

    def string_data?(value)
      return true if value.is_a?(String)

      values = if value.is_a?(Numo::RObject)
                 value.to_a.flatten
               elsif value.is_a?(Array)
                 value.flatten
               else
                 []
               end
      !values.empty? && values.all? { |item| item.is_a?(String) }
    end

    def normalize_data(value)
      return [[normalize(value)], []] if value.is_a?(String)
      return [value.to_a.flatten.map { |item| normalize(item) }, value.shape] if value.is_a?(Numo::RObject)

      shape = array_shape(value)
      [value.flatten.map { |item| normalize(item) }, shape]
    end

    def array_shape(value)
      return [] unless value.is_a?(Array)
      raise HDF5::Error, 'String data must not be empty' if value.empty?

      child_shapes = value.map { |item| array_shape(item) }
      raise HDF5::ShapeError, 'String data must be rectangular' unless child_shapes.uniq.length == 1

      [value.length, *child_shapes.first]
    end

    def variable?(type_id)
      HDF5::FFI.H5Tis_variable_str(type_id).positive?
    end

    def normalize(value)
      raise HDF5::Error, 'String dataset data must be a String' unless value.is_a?(String)
      raise HDF5::Error, 'Variable-length strings cannot contain NUL bytes' if value.include?("\0")

      value.encode(Encoding::UTF_8)
    rescue EncodingError
      raise HDF5::Error, 'String dataset data must be valid UTF-8'
    end

    def check(status, operation)
      raise HDF5::Error, "Failed to #{operation}" if status < 0
    end
  end
end