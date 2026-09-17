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
      string = normalize(value)
      string_pointer = ::FFI::MemoryPointer.from_string(string)
      buffer = ::FFI::MemoryPointer.new(:pointer)
      buffer.write_pointer(string_pointer)
      [buffer, string_pointer]
    end

    def read(buffer)
      pointer = buffer.read_pointer
      pointer.null? ? nil : pointer.read_string.force_encoding(Encoding::UTF_8)
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