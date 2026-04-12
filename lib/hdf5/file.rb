module HDF5
  class File
    H5F_ACC_RDONLY = 0x0000
    H5F_ACC_RDWR = 0x0001
    H5F_ACC_TRUNC = 0x0002

    class << self
      def create(filename, flags = H5F_ACC_TRUNC)
        file = from_id(HDF5::FFI.H5Fcreate(filename, flags, HDF5::DEFAULT_PROPERTY_LIST, HDF5::DEFAULT_PROPERTY_LIST),
                       filename, flags)
        return file unless block_given?

        begin
          yield file
        ensure
          file.close
        end
      end

      def open(filename, mode = H5F_ACC_RDONLY)
        file = from_id(HDF5::FFI.H5Fopen(filename, mode, HDF5::DEFAULT_PROPERTY_LIST), filename, mode)
        return file unless block_given?

        begin
          yield file
        ensure
          file.close
        end
      end

      private

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
      return if @file_id.nil?

      HDF5::FFI.H5Fclose(@file_id)
      @file_id = nil
    end

    def create_group(name, &block)
      Group.create(@file_id, name, &block)
    end

    def create_dataset(name, data, &block)
      Dataset.create(@file_id, name, data, &block)
    end

    def list_entries
      list = []
      callback = ::FFI::Function.new(:int, %i[int64_t string pointer pointer]) do |_, name, _, _|
        list << name
        0 # continue
      end

      case HDF5::FFI::MiV
      when 10
        HDF5::FFI.H5Literate(@file_id, :H5_INDEX_NAME, :H5_ITER_NATIVE, nil, callback, nil)
      else
        HDF5::FFI.H5Literate2(@file_id, :H5_INDEX_NAME, :H5_ITER_NATIVE, nil, callback, nil)
      end.negative? && raise(HDF5::Error, 'Failed to iterate over file entries')

      list
    end

    def [](name)
      if group?(name)
        Group.open(@file_id, name)
      elsif dataset?(name)
        Dataset.open(@file_id, name)
      else
        raise HDF5::Error, "Group or dataset not found: #{name}"
      end
    end

    def attrs
      @attrs ||= AttributeManager.new(@file_id)
    end

    private

    def initialize_from_id(file_id, filename, mode)
      raise HDF5::Error, "Failed to open file: #{filename}" if file_id < 0

      @filename = filename
      @mode = mode
      @file_id = file_id
    end

    def group?(name)
      info = if HDF5::FFI::MiV == 10
               HDF5::FFI::H5OInfoT.new.tap do |i|
                 HDF5::FFI.H5Oget_info_by_name(@file_id, name, i, 0)
               end
             else
               HDF5::FFI::H5OInfo1T.new.tap do |i|
                 HDF5::FFI.H5Oget_info_by_name1(@file_id, name, i, 0)
               end
             end
      info[:type] == :H5O_TYPE_GROUP
    end

    def dataset?(name)
      info = if HDF5::FFI::MiV == 10
               HDF5::FFI::H5OInfoT.new.tap do |i|
                 HDF5::FFI.H5Oget_info_by_name(@file_id, name, i, 0)
               end
             else
               HDF5::FFI::H5OInfo1T.new.tap do |i|
                 HDF5::FFI.H5Oget_info_by_name1(@file_id, name, i, 0)
               end
             end
      info[:type] == :H5O_TYPE_DATASET
    end
  end
end
