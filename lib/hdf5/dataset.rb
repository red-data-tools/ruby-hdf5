module HDF5
  class Dataset
    def initialize(parent_id, name)
      @dataset_id = HDF5::FFI.H5Dopen1(parent_id, name)
    end

    def write(data)
      HDF5::FFI.H5Dwrite(@dataset_id, data)
    end

    def close
      HDF5::FFI.H5Dclose(@dataset_id)
    end

    def dtype
      datatype_id = HDF5::FFI.H5Dget_type(@dataset_id)
      HDF5::FFI.H5Tget_class(datatype_id)
    end

    def shape
      dataspace_id = HDF5::FFI.H5Dget_space(@dataset_id)
      raise 'Failed to get dataspace' if dataspace_id < 0

      ndims = HDF5::FFI.H5Sget_simple_extent_ndims(dataspace_id)
      raise 'Failed to get number of dimensions' if ndims < 0

      dims = ::FFI::MemoryPointer.new(:ulong_long, ndims)
      HDF5::FFI.H5Sget_simple_extent_dims(dataspace_id, dims, nil)

      dims.read_array_of_uint64(ndims)
    ensure
      HDF5::FFI.H5Sclose(dataspace_id) if dataspace_id && dataspace_id >= 0
    end

    def read
      dtype = dtype()
      shape = shape()

      total_elements = shape.inject(:*)
      case dtype
      when :H5T_INTEGER
        read_integer_data(total_elements)
      when :H5T_FLOAT
        read_float_data(total_elements)
      when :H5T_STRING
        read_string_data(total_elements)
      else
        raise 'Unsupported datatype'
      end
    end

    def read_integer_data(total_elements)
      buffer = ::FFI::MemoryPointer.new(:int, total_elements)
      mem_type_id = HDF5::FFI.H5T_NATIVE_INT
      HDF5::FFI.H5Dread(@dataset_id, mem_type_id, 0, 0, 0, buffer)
      buffer.read_array_of_int(total_elements)
    end

    def read_float_data(total_elements)
      buffer = ::FFI::MemoryPointer.new(:float, total_elements)
      mem_type_id = HDF5::FFI.H5T_NATIVE_FLOAT
      HDF5::FFI.H5Dread(@dataset_id, mem_type_id, 0, 0, 0, buffer)
      buffer.read_array_of_float(total_elements)
    end

    def read_string_data(total_elements)
      raise NotImplementedError
    end
  end
end
