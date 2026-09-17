module HDF5
  class Group
    include Hierarchy

    class << self
      def create(parent_id, name, context = nil)
        group = from_id(
          HDF5::FFI.H5Gcreate2(parent_id, name, HDF5::DEFAULT_PROPERTY_LIST, HDF5::DEFAULT_PROPERTY_LIST,
                               HDF5::DEFAULT_PROPERTY_LIST), name, context
        )
        return group unless block_given?

        begin
          yield group
        ensure
          group.close
        end
      end

      def open(parent_id, name, context = nil)
        group = from_id(HDF5::FFI.H5Gopen2(parent_id, name, HDF5::DEFAULT_PROPERTY_LIST), name, context)
        return group unless block_given?

        begin
          yield group
        ensure
          group.close
        end
      end

      private

      def from_id(group_id, name, context)
        group = allocate
        group.send(:initialize_from_id, group_id, name, context)
        group
      end
    end

    def initialize(file_id, name)
      initialize_from_id(HDF5::FFI.H5Gopen2(file_id, name, HDF5::DEFAULT_PROPERTY_LIST), name, nil)
    end

    def close
      return if @group_id.nil?

      @context ? @context.close(@group_id) : HDF5::FFI.H5Gclose(@group_id)
      @group_id = nil
    end

    def closed?
      @group_id.nil? || (@context && @context.closed?)
    end

    def create_group(name, &block)
      ensure_open!
      self.class.create(@group_id, name, @context, &block)
    end

    def create_dataset(name, data = nil, **options, &block)
      ensure_open!
      Dataset.create(@group_id, name, data, context: @context, **options, &block)
    end

    def list_entries
      ensure_open!
      entries = []
      callback = ::FFI::Function.new(:int, %i[int64_t string pointer pointer]) do |_, name, _, _|
        entries << name
        0 # continue
      end

      (if HDF5::FFI::MiV == 10
         HDF5::FFI.H5Literate(@group_id, :H5_INDEX_NAME, :H5_ITER_NATIVE, nil, callback, nil)
       else
         HDF5::FFI.H5Literate2(@group_id, :H5_INDEX_NAME, :H5_ITER_NATIVE, nil, callback, nil)
       end).negative? &&
        raise(HDF5::Error, 'Failed to list entries')

      entries
    end

    def list_datasets
      list_entries.select { |name| dataset?(name) }
    end

    def [](name)
      ensure_open!
      if group?(name)
        self.class.open(@group_id, name, @context)
      elsif dataset?(name)
        Dataset.open(@group_id, name, context: @context)
      else
        raise HDF5::Error, "Group or dataset not found: #{name}"
      end
    end

    def attrs
      ensure_open!
      @attrs ||= AttributeManager.new(@group_id, @context)
    end

    private

    def hdf5_id
      ensure_open!
      @group_id
    end

    def initialize_from_id(group_id, name, context)
      raise HDF5::Error, "Failed to open group: #{name}" if group_id < 0

      @group_id = group_id
      @name = name
      @context = context
      @context.register(group_id, :group) if @context
    end

    def ensure_open!
      raise ClosedError, 'HDF5 group is closed' if @group_id.nil?

      @context&.ensure_open!(@group_id)
    end

    def group?(name)
      info = if HDF5::FFI::MiV == 10
               HDF5::FFI::H5OInfoT.new.tap do |i|
                 HDF5::FFI.H5Oget_info_by_name(@group_id, name, i, 0)
               end
             else
               HDF5::FFI::H5OInfo1T.new.tap do |i|
                 HDF5::FFI.H5Oget_info_by_name1(@group_id, name, i, 0)
               end
             end
      info[:type] == :H5O_TYPE_GROUP
    end

    def dataset?(name)
      info = if HDF5::FFI::MiV == 10
               HDF5::FFI::H5OInfoT.new.tap do |i|
                 HDF5::FFI.H5Oget_info_by_name(@group_id, name, i, 0)
               end
             else
               HDF5::FFI::H5OInfo1T.new.tap do |i|
                 HDF5::FFI.H5Oget_info_by_name1(@group_id, name, i, 0)
               end
             end
      info[:type] == :H5O_TYPE_DATASET
    end

    prepend FileContext.guard(:create_group, :create_dataset, :list_entries, :list_datasets, :[], :attrs)
  end
end
