module HDF5
  class File
    def initialize(filename, mode = 0)
      @filename = filename
      @mode = mode
      @file_id = HDF5::FFI.H5Fopen(filename, mode, 0)
    end

    def close
      HDF5::FFI.H5Fclose(@file_id)
    end

    def create_group(name)
      Group.new(@file_id, name)
    end

    def create_dataset(name, data)
      Dataset.new(@file_id, name, data)
    end

    def list_entries
      list = []
      callback = ::FFI::Function.new(:int, %i[int64_t string pointer pointer]) do |_, name, _, _|
        list << name
        0 # continue
      end

      status = HDF5::FFI.H5Literate(@file_id, :H5_INDEX_NAME, :H5_ITER_NATIVE, nil, callback, nil)
      raise 'Failed to iterate over file entries' if status < 0

      list
    end

    def [](name)
      if group?(name)
        Group.new(@file_id, name)
      elsif dataset?(name)
        Dataset.new(@file_id, name)
      else
        raise 'Unknown object type'
      end
    end

    private

    def group?(name)
      info = HDF5::FFI::H5OInfoT.new
      HDF5::FFI.H5Oget_info_by_name(@file_id, name, info, 0)
      info[:type] == :H5O_TYPE_GROUP
    end

    def dataset?(name)
      info = HDF5::FFI::H5OInfoT.new
      HDF5::FFI.H5Oget_info_by_name(@file_id, name, info, 0)
      info[:type] == :H5O_TYPE_DATASET
    end
  end
end
