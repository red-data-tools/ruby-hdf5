module HDF5
  class Group
    def initialize(file_id, name)
      @group_id = HDF5::FFI.H5Gopen1(file_id, name)
      raise "Failed to open group: #{name}" if @group_id < 0
    end

    def close
      HDF5::FFI.H5Gclose(@group_id)
    end

    def list_datasets
      datasets = []
      callback = ::FFI::Function.new(:int, %i[int64_t string pointer pointer]) do |_, name, _, _|
        datasets << name
        0 # continue
      end

      case HDF5::FFI::MiV
      when 10 then HDF5::FFI.H5Literate(@group_id, :H5_INDEX_NAME, :H5_ITER_NATIVE, nil, callback, nil)
      when 14 then HDF5::FFI.H5Literate2(@group_id, :H5_INDEX_NAME, :H5_ITER_NATIVE, nil, callback, nil)
      end.negative? && raise('Failed to list datasets')

      datasets
    end

    def [](name)
      if group?(name)
        Group.new(@group_id, name)
      elsif dataset?(name)
        Dataset.new(@group_id, name)
      else
        raise 'Group or Dataset not found'
      end
    end

    private

    def group?(name)
      case HDF5::FFI::MiV
      when 10
        info = HDF5::FFI::H5OInfoT.new
        HDF5::FFI.H5Oget_info_by_name(@group_id, name, info, 0)
      when 14
        info = HDF5::FFI::H5OInfo1T.new
        HDF5::FFI.H5Oget_info_by_name1(@group_id, name, info, 0)
      else
        raise 'This should not happen'
      end
      info[:type] == :H5O_TYPE_GROUP
    end

    def dataset?(name)
      case HDF5::FFI::MiV
      when 10
        info = HDF5::FFI::H5OInfoT.new
        HDF5::FFI.H5Oget_info_by_name(@group_id, name, info, 0)
      when 14
        info = HDF5::FFI::H5OInfo1T.new
        HDF5::FFI.H5Oget_info_by_name1(@group_id, name, info, 0)
      else
        raise 'This should not happen'
      end
      info[:type] == :H5O_TYPE_DATASET
    end
  end
end
