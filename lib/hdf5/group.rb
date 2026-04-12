module HDF5
  class Group
    H5P_DEFAULT = 0

    class << self
      def create(parent_id, name)
        group_id = HDF5::FFI.H5Gcreate2(parent_id, name, H5P_DEFAULT, H5P_DEFAULT, H5P_DEFAULT)
        from_id(group_id, name)
      end

      def open(parent_id, name)
        from_id(HDF5::FFI.H5Gopen2(parent_id, name, H5P_DEFAULT), name)
      end

      private

      def from_id(group_id, name)
        group = allocate
        group.send(:initialize_from_id, group_id, name)
        group
      end
    end

    def initialize(file_id, name)
      initialize_from_id(HDF5::FFI.H5Gopen2(file_id, name, H5P_DEFAULT), name)
    end

    def close
      HDF5::FFI.H5Gclose(@group_id)
    end

    def create_group(name)
      self.class.create(@group_id, name)
    end

    def create_dataset(name, data)
      Dataset.create(@group_id, name, data)
    end

    def list_datasets
      datasets = []
      callback = ::FFI::Function.new(:int, %i[int64_t string pointer pointer]) do |_, name, _, _|
        datasets << name
        0 # continue
      end

      HDF5::FFI.H5Literate2(@group_id, :H5_INDEX_NAME, :H5_ITER_NATIVE, nil, callback, nil).negative? &&
        raise('Failed to list datasets')

      datasets
    end

    def [](name)
      if group?(name)
        self.class.open(@group_id, name)
      elsif dataset?(name)
        Dataset.open(@group_id, name)
      else
        raise 'Group or Dataset not found'
      end
    end

    def attrs
      @attrs ||= AttributeManager.new(@group_id)
    end

    private

    def initialize_from_id(group_id, name)
      raise "Failed to open group: #{name}" if group_id < 0

      @group_id = group_id
      @name = name
    end

    def group?(name)
      info = HDF5::FFI::H5OInfo1T.new
      HDF5::FFI.H5Oget_info_by_name1(@group_id, name, info, 0)
      info[:type] == :H5O_TYPE_GROUP
    end

    def dataset?(name)
      info = HDF5::FFI::H5OInfo1T.new
      HDF5::FFI.H5Oget_info_by_name1(@group_id, name, info, 0)
      info[:type] == :H5O_TYPE_DATASET
    end
  end
end
