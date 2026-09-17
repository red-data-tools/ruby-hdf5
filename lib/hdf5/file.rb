module HDF5
  class File
    include Hierarchy

    H5F_ACC_RDONLY = 0x0000
    H5F_ACC_RDWR = 0x0001
    H5F_ACC_TRUNC = 0x0002
    H5F_ACC_EXCL = 0x0004

    class << self
      def create(filename, flags = H5F_ACC_TRUNC)
        file = from_id(HDF5::FFI.H5Fcreate(filename, flags, HDF5::DEFAULT_PROPERTY_LIST, HDF5::DEFAULT_PROPERTY_LIST),
                       filename, flags)
        return file unless block_given?

        begin
          yield file
        ensure
          Native.close_object(file)
        end
      end

      def open(filename, mode = 'r')
        file_id, flags = open_file(filename, mode)
        file = from_id(file_id, filename, flags)
        return file unless block_given?

        begin
          yield file
        ensure
          Native.close_object(file)
        end
      end

      private

      def open_file(filename, mode)
        return [HDF5::FFI.H5Fopen(filename, mode, HDF5::DEFAULT_PROPERTY_LIST), mode] if mode.is_a?(Integer)

        case mode
        when 'r'
          [HDF5::FFI.H5Fopen(filename, H5F_ACC_RDONLY, HDF5::DEFAULT_PROPERTY_LIST), H5F_ACC_RDONLY]
        when 'r+'
          [HDF5::FFI.H5Fopen(filename, H5F_ACC_RDWR, HDF5::DEFAULT_PROPERTY_LIST), H5F_ACC_RDWR]
        when 'w'
          [HDF5::FFI.H5Fcreate(filename, H5F_ACC_TRUNC, HDF5::DEFAULT_PROPERTY_LIST, HDF5::DEFAULT_PROPERTY_LIST),
           H5F_ACC_TRUNC]
        when 'x'
          [HDF5::FFI.H5Fcreate(filename, H5F_ACC_EXCL, HDF5::DEFAULT_PROPERTY_LIST, HDF5::DEFAULT_PROPERTY_LIST),
           H5F_ACC_EXCL]
        when 'a'
          file_id = HDF5::FFI.H5Fcreate(filename, H5F_ACC_EXCL, HDF5::DEFAULT_PROPERTY_LIST, HDF5::DEFAULT_PROPERTY_LIST)
          file_id = HDF5::FFI.H5Fopen(filename, H5F_ACC_RDWR, HDF5::DEFAULT_PROPERTY_LIST) if file_id < 0
          [file_id, H5F_ACC_RDWR]
        else
          raise ArgumentError, "Unsupported file mode: #{mode.inspect}"
        end
      end

      def from_id(file_id, filename, mode)
        file = allocate
        file.send(:initialize_from_id, file_id, filename, mode)
        file
      end
    end

    def initialize(filename, mode = H5F_ACC_RDONLY)
      initialize_from_id(HDF5::FFI.H5Fopen(filename, mode, HDF5::DEFAULT_PROPERTY_LIST), filename, mode)
    end

    def close
      return if @file_id.nil? || @context.closed?

      @context.close_file
      @file_id = nil
    end

    def closed?
      @file_id.nil? || @context.closed?
    end

    def flush
      ensure_open!
      status = HDF5::FFI.H5Fflush(@file_id, :H5F_SCOPE_GLOBAL)
      raise NativeError, 'Failed to flush file' if status < 0

      self
    end

    def create_group(name, &block)
      group = @context.synchronize do
        ensure_open!
        Group.create(@file_id, name, @context)
      end
      return group unless block

      begin
        block.call(group)
      ensure
        Native.close_object(group)
      end
    end

    def create_dataset(name, data = nil, **options, &block)
      dataset = @context.synchronize do
        ensure_open!
        Dataset.create(@file_id, name, data, context: @context, **options)
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
      list = []
      callback = ::FFI::Function.new(:int, %i[int64_t string pointer pointer]) do |_, name, _, _|
        list << name
        0 # continue
      end

      status = if HDF5::FFI::MiV == 10
                 HDF5::FFI.H5Literate(@file_id, :H5_INDEX_NAME, :H5_ITER_NATIVE, nil, callback, nil)
               else
                 HDF5::FFI.H5Literate2(@file_id, :H5_INDEX_NAME, :H5_ITER_NATIVE, nil, callback, nil)
               end
      Native.check(status, 'Failed to iterate over file entries')

      list
    end

    def [](name)
      ensure_open!
      case object_type(name)
      when :H5O_TYPE_GROUP
        Group.open(@file_id, name, @context)
      when :H5O_TYPE_DATASET
        Dataset.open(@file_id, name, context: @context)
      else
        raise UnsupportedTypeError, "Object is not a group or dataset: #{name}"
      end
    end

    def attrs
      ensure_open!
      @attrs ||= AttributeManager.new(@file_id, @context)
    end

    private

    def hdf5_id
      ensure_open!
      @file_id
    end

    def initialize_from_id(file_id, filename, mode)
      raise NativeError, "Failed to open file: #{filename}" if file_id < 0

      @filename = filename
      @mode = mode
      @file_id = file_id
      @context = FileContext.new(file_id)
    end

    def ensure_open!
      raise ClosedError, 'HDF5 file is closed' if @file_id.nil?

      @context.ensure_open!(@file_id)
    end

    prepend FileContext.guard(:flush, :list_entries, :[], :attrs, :close, :closed?)
  end
end
