module HDF5
  module DataHelpers
    module_function

    def normalize_data(data, label: 'Data')
      return data if data.is_a?(Numo::NArray) && DType.for_numo(data)

      values = data.is_a?(Array) ? data.flatten : [data]
      raise HDF5::Error, "#{label} must not be empty" if values.empty?

      dtype = if values.all? { |value| value.is_a?(Integer) }
                DType.for_symbol(:int64)
              elsif values.all? { |value| value.is_a?(Numeric) }
                DType.for_symbol(:float64)
              else
                raise HDF5::Error, "Only numeric #{label.downcase} is supported"
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
end