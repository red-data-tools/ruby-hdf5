module HDF5
  class File
    H5F_ACC_RDONLY = 0x0000
    H5F_ACC_RDWR = 0x0001
    H5F_ACC_TRUNC = 0x0002
    H5P_DEFAULT = 0

    class << self
      def create(filename, flags = H5F_ACC_TRUNC)
        file_id = HDF5::FFI.H5Fcreate(filename, flags, H5P_DEFAULT, H5P_DEFAULT)
        from_id(file_id, filename, flags)
      end

      def open(filename, mode = H5F_ACC_RDONLY)
        from_id(HDF5::FFI.H5Fopen(filename, mode, H5P_DEFAULT), filename, mode)
      end

      private

      def from_id(file_id, filename, mode)
        file = allocate
        file.send(:initialize_from_id, file_id, filename, mode)
        file
      end
    end

    def initialize(filename, mode = H5F_ACC_RDONLY)
      initialize_from_id(HDF5::FFI.H5Fopen(filename, mode, H5P_DEFAULT), filename, mode)
    end

    def close
      HDF5::FFI.H5Fclose(@file_id)
    end

    def create_group(name)
      Group.create(@file_id, name)
    end

    def create_dataset(name, data)
      Dataset.create(@file_id, name, data)
    end

    def list_entries
      list = []
      callback = ::FFI::Function.new(:int, %i[int64_t string pointer pointer]) do |_, name, _, _|
        list << name
        0 # continue
      end

      case FFI::MiV
      when 10 then HDF5::FFI.H5Literate(@file_id, :H5_INDEX_NAME, :H5_ITER_NATIVE, nil, callback, nil)
      when 14 then HDF5::FFI.H5Literate2(@file_id, :H5_INDEX_NAME, :H5_ITER_NATIVE, nil, callback, nil)
      end.negative? && raise('Failed to iterate over file entries')

      list
    end

    def [](name)
      if group?(name)
        Group.open(@file_id, name)
      elsif dataset?(name)
        Dataset.open(@file_id, name)
      else
        raise 'Unknown object type'
      end
    end

    def attrs
      @attrs ||= AttributeManager.new(@file_id)
    end

    private

    def initialize_from_id(file_id, filename, mode)
      raise "Failed to open file: #{filename}" if file_id < 0

      @filename = filename
      @mode = mode
      @file_id = file_id
    end

    def group?(name)
      info = HDF5::FFI::H5OInfo1T.new
      HDF5::FFI.H5Oget_info_by_name1(@file_id, name, info, 0)
      info[:type] == :H5O_TYPE_GROUP
    end

    def dataset?(name)
      info = HDF5::FFI::H5OInfo1T.new
      HDF5::FFI.H5Oget_info_by_name1(@file_id, name, info, 0)
      info[:type] == :H5O_TYPE_DATASET
    end
  end
end
