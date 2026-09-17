module HDF5
  module DataHelpers
    module_function

    def normalize_data(data, label: 'Data')
      return data if data.is_a?(Numo::NArray) && DType.for_numo(data)

      values = data.is_a?(Array) ? data.flatten : [data]
      raise HDF5::Error, "#{label} must not be empty" if values.empty?

      dtype = if values.all? { |value| value.is_a?(Integer) }
                DType.for_symbol(:int64)
              elsif values.all? { |value| [true, false].include?(value) }
                DType.for_symbol(:bool)
              elsif values.all? { |value| value.is_a?(Numeric) } && values.any? { |value| value.is_a?(Complex) }
                DType.for_symbol(:complex128)
              elsif values.all? { |value| value.is_a?(Numeric) }
                DType.for_symbol(:float64)
              else
                raise HDF5::Error, "Only numeric #{label.downcase} is supported"
              end
      normalized = dtype.kind == :bool ? normalize_booleans(data) : data
      dtype.numo_class.cast(normalized)
    end

    def buffer_for(narray)
      dtype = DType.for_numo(narray)
      binary = if dtype.kind == :bool
                 narray.to_a.flatten.map { |value| value.zero? ? 0 : 1 }.pack('C*')
               else
                 narray.to_binary
               end
      expected_bytes = narray.size * dtype.itemsize
      raise HDF5::Error, 'Numo binary representation has an unexpected size' unless binary.bytesize == expected_bytes

      ::FFI::MemoryPointer.new(:char, expected_bytes).tap { |buffer| buffer.put_bytes(0, binary) }
    end

    def from_binary(dtype, binary, shape)
      return dtype.numo_class.from_binary(binary, shape) unless dtype.kind == :bool

      bytes = binary.unpack('C*')
      return Numo::Bit.new.store(bytes.first) if shape.empty?

      Numo::UInt8.cast(bytes).reshape(*shape).ne(0)
    end

    def normalize_booleans(value)
      return value.map { |item| normalize_booleans(item) } if value.is_a?(Array)

      value ? 1 : 0
    end
  end
end
