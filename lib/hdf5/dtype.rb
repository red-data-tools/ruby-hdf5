module HDF5
  class DType
    TYPES = {
      int8: [Numo::Int8, :H5T_NATIVE_INT8_g, :H5T_STD_I8LE_g, :int8, 1],
      uint8: [Numo::UInt8, :H5T_NATIVE_UINT8_g, :H5T_STD_U8LE_g, :uint8, 1],
      int16: [Numo::Int16, :H5T_NATIVE_INT16_g, :H5T_STD_I16LE_g, :int16, 2],
      uint16: [Numo::UInt16, :H5T_NATIVE_UINT16_g, :H5T_STD_U16LE_g, :uint16, 2],
      int32: [Numo::Int32, :H5T_NATIVE_INT32_g, :H5T_STD_I32LE_g, :int32, 4],
      uint32: [Numo::UInt32, :H5T_NATIVE_UINT32_g, :H5T_STD_U32LE_g, :uint32, 4],
      int64: [Numo::Int64, :H5T_NATIVE_INT64_g, :H5T_STD_I64LE_g, :int64, 8],
      uint64: [Numo::UInt64, :H5T_NATIVE_UINT64_g, :H5T_STD_U64LE_g, :uint64, 8],
      float32: [Numo::SFloat, :H5T_NATIVE_FLOAT, :H5T_IEEE_F32LE_g, :float, 4],
      float64: [Numo::DFloat, :H5T_NATIVE_DOUBLE, :H5T_IEEE_F64LE_g, :float, 8]
    }.freeze

    attr_reader :numo_class, :memory_type_name, :storage_type_name, :kind, :itemsize

    def self.for_numo(value)
      type = TYPES.values.find { |numo_class,| value.is_a?(numo_class) }
      raise HDF5::Error, "Unsupported Numo type: #{value.class}" unless type

      new(*type)
    end

    def self.for_symbol(symbol)
      type = TYPES.fetch(symbol) { raise HDF5::Error, "Unsupported dtype: #{symbol.inspect}" }
      new(*type)
    end

    def self.for_hdf5(type_id)
      type_class = HDF5::FFI.H5Tget_class(type_id)
      itemsize = HDF5::FFI.H5Tget_size(type_id)
      symbol = case type_class
               when :H5T_INTEGER
                 prefix = HDF5::FFI.H5Tget_sign(type_id) == :H5T_SGN_NONE ? 'uint' : 'int'
                 "#{prefix}#{itemsize * 8}".to_sym
               when :H5T_FLOAT
                 "float#{itemsize * 8}".to_sym
               else
                 raise HDF5::Error, "Unsupported HDF5 datatype: #{type_class}"
               end

      for_symbol(symbol)
    end

    def initialize(numo_class, memory_type_name, storage_type_name, kind, itemsize)
      @numo_class = numo_class
      @memory_type_name = memory_type_name
      @storage_type_name = storage_type_name
      @kind = kind
      @itemsize = itemsize
    end

    def memory_type_id
      HDF5::FFI.public_send(memory_type_name)
    end

    def storage_type_id
      HDF5::FFI.public_send(storage_type_name)
    end

    def to_sym
      TYPES.find { |_, type| type[0] == numo_class }&.first
    end
  end
end