module HDF5
  class DType
    TYPES = {
      int8: [Numo::Int8, :H5T_NATIVE_INT8_g, :H5T_STD_I8LE_g, :integer, 1],
      uint8: [Numo::UInt8, :H5T_NATIVE_UINT8_g, :H5T_STD_U8LE_g, :integer, 1],
      int16: [Numo::Int16, :H5T_NATIVE_INT16_g, :H5T_STD_I16LE_g, :integer, 2],
      uint16: [Numo::UInt16, :H5T_NATIVE_UINT16_g, :H5T_STD_U16LE_g, :integer, 2],
      int32: [Numo::Int32, :H5T_NATIVE_INT32_g, :H5T_STD_I32LE_g, :integer, 4],
      uint32: [Numo::UInt32, :H5T_NATIVE_UINT32_g, :H5T_STD_U32LE_g, :integer, 4],
      int64: [Numo::Int64, :H5T_NATIVE_INT64_g, :H5T_STD_I64LE_g, :integer, 8],
      uint64: [Numo::UInt64, :H5T_NATIVE_UINT64_g, :H5T_STD_U64LE_g, :integer, 8],
      float32: [Numo::SFloat, :H5T_NATIVE_FLOAT, :H5T_IEEE_F32LE_g, :float, 4],
      float64: [Numo::DFloat, :H5T_NATIVE_DOUBLE, :H5T_IEEE_F64LE_g, :float, 8],
      bool: [Numo::Bit, nil, nil, :bool, 1],
      complex64: [Numo::SComplex, nil, nil, :complex, 8],
      complex128: [Numo::DComplex, nil, nil, :complex, 16]
    }.freeze

    attr_reader :numo_class, :memory_type_name, :storage_type_name, :kind, :itemsize, :byteorder, :precision, :offset,
                :hdf5_class

    def self.for_numo(value)
      type = TYPES.values.find { |numo_class,| value.is_a?(numo_class) }
      raise HDF5::Error, "Unsupported Numo type: #{value.class}" unless type

      symbol = TYPES.key(type)
      new(symbol, *type)
    end

    def self.for_symbol(symbol)
      type = TYPES.fetch(symbol) { raise HDF5::Error, "Unsupported dtype: #{symbol.inspect}" }
      new(symbol, *type)
    end

    def self.for_hdf5(type_id)
      type_class = HDF5::FFI.H5Tget_class(type_id)
      itemsize = HDF5::FFI.H5Tget_size(type_id)
      return for_bool_hdf5(type_id, itemsize) if type_class == :H5T_ENUM
      return for_complex_hdf5(type_id, itemsize) if type_class == :H5T_COMPOUND

      symbol = case type_class
               when :H5T_INTEGER
                 prefix = HDF5::FFI.H5Tget_sign(type_id) == :H5T_SGN_NONE ? 'uint' : 'int'
                 "#{prefix}#{itemsize * 8}".to_sym
               when :H5T_FLOAT
                 "float#{itemsize * 8}".to_sym
               else
                 raise UnsupportedTypeError, "Unsupported HDF5 datatype: #{type_class}"
               end

      precision = HDF5::FFI.H5Tget_precision(type_id)
      offset = HDF5::FFI.H5Tget_offset(type_id)
      unless precision == itemsize * 8
        raise UnsupportedTypeError,
              "Unsupported #{precision}-bit datatype in #{itemsize * 8}-bit storage"
      end
      raise UnsupportedTypeError, "Unsupported datatype bit offset: #{offset}" unless offset.zero?

      order = HDF5::FFI.H5Tget_order(type_id)
      byteorder = { H5T_ORDER_LE: :little, H5T_ORDER_BE: :big, H5T_ORDER_NONE: :none }.fetch(order) do
        raise UnsupportedTypeError, "Unsupported datatype byte order: #{order}"
      end
      new(symbol, *TYPES.fetch(symbol), byteorder:, precision:, offset:, hdf5_class: type_class)
    end

    def self.for_bool_hdf5(type_id, itemsize)
      false_value = ::FFI::MemoryPointer.new(:int8)
      true_value = ::FFI::MemoryPointer.new(:int8)
      valid = itemsize == 1 && HDF5::FFI.H5Tget_nmembers(type_id) == 2 &&
              HDF5::FFI.H5Tenum_valueof(type_id, 'FALSE', false_value) >= 0 &&
              HDF5::FFI.H5Tenum_valueof(type_id, 'TRUE', true_value) >= 0 &&
              false_value.read_int8.zero? && true_value.read_int8 == 1
      raise UnsupportedTypeError, 'Unsupported HDF5 enum datatype' unless valid

      new(:bool, *TYPES.fetch(:bool), byteorder: :none, hdf5_class: :H5T_ENUM)
    end

    def self.for_complex_hdf5(type_id, itemsize)
      component_size = itemsize / 2
      real_index = HDF5::FFI.H5Tget_member_index(type_id, 'r')
      imaginary_index = HDF5::FFI.H5Tget_member_index(type_id, 'i')
      valid = [8, 16].include?(itemsize) && real_index >= 0 && imaginary_index >= 0 &&
              HDF5::FFI.H5Tget_nmembers(type_id) == 2 &&
              HDF5::FFI.H5Tget_member_offset(type_id, real_index) == 0 &&
              HDF5::FFI.H5Tget_member_offset(type_id, imaginary_index) == component_size
      [real_index, imaginary_index].each do |index|
        next unless index >= 0

        member_type_id = HDF5::FFI.H5Tget_member_type(type_id, index)
        valid &&= member_type_id >= 0 && HDF5::FFI.H5Tget_class(member_type_id) == :H5T_FLOAT &&
                  HDF5::FFI.H5Tget_size(member_type_id) == component_size
        HDF5::FFI.H5Tclose(member_type_id) if member_type_id >= 0
      end
      raise UnsupportedTypeError, 'Unsupported HDF5 compound datatype' unless valid

      symbol = itemsize == 8 ? :complex64 : :complex128
      new(symbol, *TYPES.fetch(symbol), hdf5_class: :H5T_COMPOUND)
    end

    def initialize(symbol, numo_class, memory_type_name, storage_type_name, kind, itemsize, byteorder: :little,
                   precision: itemsize * 8, offset: 0, hdf5_class: nil)
      @symbol = symbol
      @numo_class = numo_class
      @memory_type_name = memory_type_name
      @storage_type_name = storage_type_name
      @kind = kind
      @itemsize = itemsize
      @byteorder = byteorder
      @precision = precision
      @offset = offset
      @hdf5_class = hdf5_class || (kind == :integer ? :H5T_INTEGER : :H5T_FLOAT)
      freeze
    end

    def memory_type_id
      return self.class.bool_type_id(native: true) if kind == :bool
      return self.class.complex_type_id(itemsize, native: true) if kind == :complex

      HDF5::FFI.public_send(memory_type_name)
    end

    def storage_type_id
      return self.class.bool_type_id(native: false) if kind == :bool
      return self.class.complex_type_id(itemsize, native: false) if kind == :complex

      HDF5::FFI.public_send(storage_type_name)
    end

    def to_sym
      @symbol
    end

    def castable_to?(target, casting: :safe)
      raise ArgumentError, "Unsupported casting mode: #{casting.inspect}" unless %i[safe unsafe].include?(casting)
      return true if casting == :unsafe || to_sym == target.to_sym

      if kind == :integer && target.kind == :integer
        return itemsize <= target.itemsize if unsigned? == target.unsigned?
        return false unless unsigned? && !target.unsigned?

        return itemsize < target.itemsize
      end
      return itemsize <= target.itemsize if kind == :float && target.kind == :float

      if kind == :integer && target.kind == :float
        significant_bits = unsigned? ? itemsize * 8 : itemsize * 8 - 1
        mantissa_bits = target.itemsize == 4 ? 24 : 53
        return significant_bits <= mantissa_bits
      end

      false
    end

    def unsigned?
      @symbol.to_s.start_with?('uint')
    end

    class << self
      def bool_type_id(native:)
        @bool_type_ids ||= {}
        @bool_type_ids[native] ||= begin
          base_id = HDF5::FFI.public_send(native ? :H5T_NATIVE_INT8_g : :H5T_STD_I8LE_g)
          type_id = HDF5::FFI.H5Tenum_create(base_id)
          raise HDF5::Error, 'Failed to create bool datatype' if type_id < 0

          false_value = ::FFI::MemoryPointer.new(:int8).tap { |pointer| pointer.write_int8(0) }
          true_value = ::FFI::MemoryPointer.new(:int8).tap { |pointer| pointer.write_int8(1) }
          if HDF5::FFI.H5Tenum_insert(type_id, 'FALSE', false_value) < 0 ||
             HDF5::FFI.H5Tenum_insert(type_id, 'TRUE', true_value) < 0
            HDF5::FFI.H5Tclose(type_id)
            raise HDF5::Error, 'Failed to define bool datatype'
          end

          type_id
        end
      end

      def complex_type_id(size, native:)
        @complex_type_ids ||= {}
        @complex_type_ids[[size, native]] ||= begin
          component_id = if native
                           HDF5::FFI.public_send(size == 8 ? :H5T_NATIVE_FLOAT : :H5T_NATIVE_DOUBLE)
                         else
                           HDF5::FFI.public_send(size == 8 ? :H5T_IEEE_F32LE_g : :H5T_IEEE_F64LE_g)
                         end
          type_id = HDF5::FFI.H5Tcreate(:H5T_COMPOUND, size)
          raise HDF5::Error, 'Failed to create complex datatype' if type_id < 0

          if HDF5::FFI.H5Tinsert(type_id, 'r', 0, component_id) < 0 ||
             HDF5::FFI.H5Tinsert(type_id, 'i', size / 2, component_id) < 0
            HDF5::FFI.H5Tclose(type_id)
            raise HDF5::Error, 'Failed to define complex datatype'
          end

          type_id
        end
      end
    end
  end
end
