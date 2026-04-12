module HDF5
  class Dataset
    H5P_DEFAULT = 0

    class << self
      def create(parent_id, name, data)
        values = normalize_data(data)
        dims = ::FFI::MemoryPointer.new(:ulong_long, 1)
        dims.write_array_of_ulong_long([values.length])
        datatype_id = datatype_id_for(values)
        dataspace_id = HDF5::FFI.H5Screate_simple(1, dims, nil)
        raise "Failed to create dataspace for dataset: #{name}" if dataspace_id < 0

        dataset_id = HDF5::FFI.H5Dcreate2(parent_id, name, datatype_id, dataspace_id, H5P_DEFAULT, H5P_DEFAULT,
                                          H5P_DEFAULT)
        dataset = from_id(dataset_id, name)
        dataset.write(values)
        dataset
      ensure
        HDF5::FFI.H5Sclose(dataspace_id) if dataspace_id && dataspace_id >= 0
      end

      def open(parent_id, name)
        from_id(HDF5::FFI.H5Dopen2(parent_id, name, H5P_DEFAULT), name)
      end

      def normalize_data(data)
        values = data.is_a?(Array) ? data : [data]
        raise 'Dataset data must not be empty' if values.empty?
        raise 'Nested arrays are not supported' if values.any? { |value| value.is_a?(Array) }

        values
      end

      def datatype_id_for(data)
        if data.all? { |value| value.is_a?(Integer) }
          HDF5::FFI.H5T_NATIVE_INT
        elsif data.all? { |value| value.is_a?(Numeric) }
          HDF5::FFI.H5T_NATIVE_DOUBLE
        else
          raise 'Only numeric dataset data is supported'
        end
      end

      def buffer_for(data)
        if data.all? { |value| value.is_a?(Integer) }
          buffer = ::FFI::MemoryPointer.new(:int, data.length)
          buffer.write_array_of_int(data)
        else
          buffer = ::FFI::MemoryPointer.new(:double, data.length)
          buffer.write_array_of_double(data.map(&:to_f))
        end

        buffer
      end

      private

      def from_id(dataset_id, name)
        dataset = allocate
        dataset.send(:initialize_from_id, dataset_id, name)
        dataset
      end
    end

    def initialize(parent_id, name)
      initialize_from_id(HDF5::FFI.H5Dopen2(parent_id, name, H5P_DEFAULT), name)
    end

    def attrs
      @attrs ||= AttributeManager.new(@dataset_id)
    end

    def write(data)
      values = self.class.normalize_data(data)
      buffer = self.class.buffer_for(values)
      mem_type_id = self.class.datatype_id_for(values)
      status = HDF5::FFI.H5Dwrite(@dataset_id, mem_type_id, H5P_DEFAULT, H5P_DEFAULT, H5P_DEFAULT, buffer)
      raise 'Failed to write dataset' if status < 0

      data
    end

    def close
      HDF5::FFI.H5Dclose(@dataset_id)
    end

    def dtype
      datatype_id = HDF5::FFI.H5Dget_type(@dataset_id)
      raise 'Failed to get datatype' if datatype_id < 0

      HDF5::FFI.H5Tget_class(datatype_id)
    ensure
      HDF5::FFI.H5Tclose(datatype_id) if datatype_id && datatype_id >= 0
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
      status = HDF5::FFI.H5Dread(@dataset_id, HDF5::FFI.H5T_NATIVE_INT, H5P_DEFAULT, H5P_DEFAULT, H5P_DEFAULT, buffer)
      raise 'Failed to read integer dataset' if status < 0

      buffer.read_array_of_int(total_elements)
    end

    def read_float_data(total_elements)
      buffer = ::FFI::MemoryPointer.new(:double, total_elements)
      status = HDF5::FFI.H5Dread(@dataset_id, HDF5::FFI.H5T_NATIVE_DOUBLE, H5P_DEFAULT, H5P_DEFAULT, H5P_DEFAULT,
                                 buffer)
      raise 'Failed to read float dataset' if status < 0

      buffer.read_array_of_double(total_elements)
    end

    def read_string_data(total_elements)
      raise NotImplementedError
    end

    private

    def initialize_from_id(dataset_id, name)
      raise "Failed to open dataset: #{name}" if dataset_id < 0

      @dataset_id = dataset_id
      @name = name
    end
  end
end
