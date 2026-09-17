module HDF5
  module DataHelpers
    module_function

    def validate_casting!(casting)
      raise ArgumentError, "Unsupported casting mode: #{casting.inspect}" unless %i[safe unsafe].include?(casting)
    end

    def normalize_data(data, label: 'Data', dtype: nil, casting: :safe, convert: true)
      validate_casting!(casting)

      if data.is_a?(Numo::NArray)
        source = DType.for_numo(data)
        return data unless dtype
        unless source.castable_to?(dtype, casting:)
          raise ConversionError, "Cannot safely cast #{source.to_sym} to #{dtype.to_sym}"
        end
        return data if source.to_sym == dtype.to_sym
        # HDF5 converts numeric widths and matching complex compounds directly,
        # but cannot convert a real numeric datatype to a complex compound.
        native_conversion = dtype.kind != :complex || source.kind == :complex
        return data if !convert && casting == :safe && native_conversion

        return dtype.numo_class.cast(data)
      end

      # Homogeneous flat Arrays need no recursive shape traversal or per-value
      # conversion checks: integer extrema cover the range; Ruby Float is float64.
      if dtype.nil? && data.is_a?(Array) && !data.empty?
        homogeneous = normalize_homogeneous_array(data, data, casting:)
        return homogeneous if homogeneous
      end

      shape = array_shape(data)
      values = data.is_a?(Array) ? (shape.length <= 1 ? data : data.flatten) : [data]
      raise ConversionError, "#{label} must not be empty without an explicit dtype" if values.empty? && !dtype

      if dtype.nil? && shape.length > 1
        homogeneous = normalize_homogeneous_array(data, values, casting:)
        return homogeneous if homogeneous
      end

      dtype ||= inferred_dtype(values, label:)
      validate_values(values, dtype, casting:)
      normalized = dtype.kind == :bool ? normalize_booleans(data) : data
      return dtype.numo_class.new(*shape) if values.empty?
      return Numo::Bit.new.store(normalized) if dtype.kind == :bool && !data.is_a?(Array)

      dtype.numo_class.cast(normalized)
    end

    def normalize_homogeneous_array(data, values, casting:)
      if values.all? { |value| value.is_a?(Integer) }
        minimum, maximum = values.minmax
        dtype = DType.for_symbol(minimum >= 0 && maximum >= (1 << 63) ? :uint64 : :int64)
        validate_values([minimum, maximum], dtype, casting:)
        dtype.numo_class.cast(data)
      elsif values.all? { |value| value.is_a?(Float) }
        Numo::DFloat.cast(data)
      end
    end

    def inferred_dtype(values, label:)
      kind = nil
      minimum = maximum = 0
      values.each do |value|
        if value.is_a?(Integer)
          current = :int64
          minimum = value if value < minimum
          maximum = value if value > maximum
        elsif value.is_a?(Complex)
          current = :complex128
        elsif value.is_a?(Numeric)
          current = :float64
        elsif value.equal?(true) || value.equal?(false)
          current = :bool
        else
          raise ConversionError, "Only numeric #{label.downcase} is supported"
        end
        if kind && (kind == :bool) != (current == :bool)
          raise ConversionError, "Only numeric #{label.downcase} is supported"
        end
        kind = current if kind.nil? || current == :complex128 || current == :float64 && kind == :int64
      end
      kind = :uint64 if kind == :int64 && minimum >= 0 && maximum >= (1 << 63)
      DType.for_symbol(kind)
    end

    def array_shape(value)
      return [] unless value.is_a?(Array)
      return [0] if value.empty?

      unless value.first.is_a?(Array)
        raise ShapeError, 'Data must be rectangular' if value.any? { |item| item.is_a?(Array) }

        return [value.length]
      end

      child_shape = array_shape(value.first)
      index = 1
      while index < value.length
        item = value[index]
        unless item.is_a?(Array) && array_shape(item) == child_shape
          raise ShapeError, 'Data must be rectangular'
        end
        index += 1
      end

      [value.length, *child_shape]
    end

    def scalar?(value)
      value.is_a?(Numeric) || value.equal?(true) || value.equal?(false) ||
        value.is_a?(Numo::NArray) && value.shape.empty?
    end

    def validate_values(values, dtype, casting:)
      if dtype.kind == :bool
        unless values.all? { |value| value.equal?(true) || value.equal?(false) }
          raise ConversionError, 'Bool data must contain true or false'
        end
        return
      end
      if casting == :unsafe
        raise ConversionError, 'Data must contain numeric values' unless values.all? { |value| value.is_a?(Numeric) }
        return
      end

      case dtype.kind
      when :integer
        bits = dtype.itemsize * 8
        minimum = dtype.unsigned? ? 0 : -(1 << (bits - 1))
        maximum = dtype.unsigned? ? (1 << bits) - 1 : (1 << (bits - 1)) - 1
        values.each do |value|
          unless value.is_a?(Integer) && value.between?(minimum, maximum)
            raise ConversionError, "Value #{value.inspect} cannot safely be represented as #{dtype.to_sym}"
          end
        end
      when :float, :complex
        size = dtype.kind == :complex ? dtype.itemsize / 2 : dtype.itemsize
        values.each do |value|
          raise ConversionError, 'Data must contain numeric values' unless value.is_a?(Numeric)
          if dtype.kind == :complex
            validate_component(value.real, size, dtype)
            validate_component(value.imag, size, dtype)
          else
            validate_component(value, size, dtype)
          end
        end
      end
    end

    def validate_component(component, size, dtype)
      return if size == 8 && component.is_a?(Float)

      raise ConversionError, "Cannot safely cast complex data to #{dtype.to_sym}" if component.is_a?(Complex)

      converted = component.to_f
      converted = [converted].pack('f').unpack1('f') if size == 4
      return if component.is_a?(Float) && !component.finite? && !converted.finite?
      return if component.is_a?(Float) && component == converted
      return if converted.finite? && converted.to_r == component.to_r

      raise ConversionError, "Value #{component.inspect} cannot safely be represented as #{dtype.to_sym}"
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
