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

    def buffer_for_values(values, encoding: Encoding::UTF_8)
      pointers = values.map { |value| ::FFI::MemoryPointer.from_string(normalize(value, encoding:)) }
      buffer = ::FFI::MemoryPointer.new(:pointer, pointers.length)
      buffer.write_array_of_pointer(pointers)
      [buffer, pointers]
    end

    def read(buffer, encoding: Encoding::UTF_8)
      read_values(buffer, 1, [], encoding:)
    end

    def read_values(buffer, count, shape, encoding: Encoding::UTF_8)
      values = buffer.read_array_of_pointer(count).map do |pointer|
        next nil if pointer.null?

        value = pointer.read_string.force_encoding(encoding)
        raise HDF5::Error, "String data is not valid #{encoding.name}" unless value.valid_encoding?

        value
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

    def normalize_data(value, encoding: Encoding::UTF_8)
      return [[normalize(value, encoding:)], []] if value.is_a?(String)
      return [value.to_a.flatten.map { |item| normalize(item, encoding:) }, value.shape] if value.is_a?(Numo::RObject)

      shape = array_shape(value)
      [value.flatten.map { |item| normalize(item, encoding:) }, shape]
    end

    def array_shape(value)
      return [] unless value.is_a?(Array)
      raise HDF5::Error, 'String data must not be empty' if value.empty?

      DataHelpers.array_shape(value)
    end

    def variable?(type_id)
      HDF5::FFI.H5Tis_variable_str(type_id).positive?
    end

    def encoding_for(type_id)
      case HDF5::FFI.H5Tget_cset(type_id)
      when :H5T_CSET_ASCII then Encoding::US_ASCII
      when :H5T_CSET_UTF8 then Encoding::UTF_8
      else raise UnsupportedTypeError, 'Unsupported HDF5 string encoding'
      end
    end

    def normalize(value, encoding: Encoding::UTF_8)
      raise HDF5::Error, 'String dataset data must be a String' unless value.is_a?(String)
      raise HDF5::Error, 'String data has an invalid encoding' unless value.valid_encoding?
      raise HDF5::Error, 'Variable-length strings cannot contain NUL bytes' if value.include?("\0")

      result = value.encode(encoding)
      raise HDF5::Error, "String data is not valid #{encoding.name}" unless result.valid_encoding?

      result
    rescue EncodingError
      raise HDF5::Error, "String data must be representable as #{encoding.name}"
    end

    def check(status, operation)
      raise HDF5::Error, "Failed to #{operation}" if status < 0
    end
  end
end
