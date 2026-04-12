module HDF5
  class Group
    class << self
      def create(parent_id, name)
        group = from_id(
          HDF5::FFI.H5Gcreate2(parent_id, name, HDF5::DEFAULT_PROPERTY_LIST, HDF5::DEFAULT_PROPERTY_LIST,
                               HDF5::DEFAULT_PROPERTY_LIST), name
        )
        return group unless block_given?

        begin
          yield group
        ensure
          group.close
        end
      end

      def open(parent_id, name)
        group = from_id(HDF5::FFI.H5Gopen2(parent_id, name, HDF5::DEFAULT_PROPERTY_LIST), name)
        return group unless block_given?

        begin
          yield group
        ensure
          group.close
        end
      end

      private

      def from_id(group_id, name)
        group = allocate
        group.send(:initialize_from_id, group_id, name)
        group
      end
    end

    def initialize(file_id, name)
      initialize_from_id(HDF5::FFI.H5Gopen2(file_id, name, HDF5::DEFAULT_PROPERTY_LIST), name)
    end

    def close
      return if @group_id.nil?

      HDF5::FFI.H5Gclose(@group_id)
      @group_id = nil
    end

    def create_group(name, &block)
      self.class.create(@group_id, name, &block)
    end

    def create_dataset(name, data, &block)
      Dataset.create(@group_id, name, data, &block)
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
        raise HDF5::Error, 'Group or Dataset not found'
      end
    end

    def attrs
      @attrs ||= AttributeManager.new(@group_id)
    end

    private

    def initialize_from_id(group_id, name)
      raise HDF5::Error, "Failed to open group: #{name}" if group_id < 0

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
