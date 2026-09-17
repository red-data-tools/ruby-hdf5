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
          Native.close_object(group)
        end
      end

      def open(parent_id, name, context = nil)
        group = from_id(HDF5::FFI.H5Gopen2(parent_id, name, HDF5::DEFAULT_PROPERTY_LIST), name, context)
        return group unless block_given?

        begin
          yield group
        ensure
          Native.close_object(group)
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

      if @context
        @context.close(@group_id)
      else
        Native.check(HDF5::FFI.H5Gclose(@group_id), 'Failed to close HDF5 group')
      end
      @group_id = nil
    end

    def closed?
      @group_id.nil? || (@context && @context.closed?)
    end

    def create_group(name, &block)
      group = HDF5::FFI::CALL_LOCK.synchronize do
        ensure_open!
        self.class.create(@group_id, name, @context)
      end
      return group unless block

      begin
        block.call(group)
      ensure
        Native.close_object(group)
      end
    end

    def create_dataset(name, data = nil, **options, &block)
      dataset = HDF5::FFI::CALL_LOCK.synchronize do
        ensure_open!
        Dataset.create(@group_id, name, data, context: @context, **options)
      end
      return dataset unless block

      begin
        block.call(dataset)
      ensure
        Native.close_object(dataset)
      end
    end

    def list_entries
      ensure_open!
      entries = []
      callback = ::FFI::Function.new(:int, %i[int64_t string pointer pointer]) do |_, name, _, _|
        entries << name
        0 # continue
      end

      status = if HDF5::FFI::MiV == 10
                 HDF5::FFI.H5Literate(@group_id, :H5_INDEX_NAME, :H5_ITER_NATIVE, nil, callback, nil)
               else
                 HDF5::FFI.H5Literate2(@group_id, :H5_INDEX_NAME, :H5_ITER_NATIVE, nil, callback, nil)
               end
      Native.check(status, 'Failed to list entries')

      entries
    end

    def list_datasets
      list_entries.select { |name| object_type(name) == :H5O_TYPE_DATASET }
    end

    def [](name)
      ensure_open!
      case object_type(name)
      when :H5O_TYPE_GROUP
        self.class.open(@group_id, name, @context)
      when :H5O_TYPE_DATASET
        Dataset.open(@group_id, name, context: @context)
      else
        raise UnsupportedTypeError, "Object is not a group or dataset: #{name}"
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
      raise NativeError, "Failed to open group: #{name}" if group_id < 0

      @group_id = group_id
      @name = name
      @context = context
      @context.register(group_id, :group) if @context
    end

    def ensure_open!
      raise ClosedError, 'HDF5 group is closed' if @group_id.nil?

      @context&.ensure_open!(@group_id)
    end

    prepend FileContext.guard(:list_entries, :list_datasets, :[], :attrs, :close, :closed?)
  end
end
