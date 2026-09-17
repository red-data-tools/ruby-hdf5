module HDF5
  module Hierarchy
    def keys
      list_entries
    end

    def each_key(&block)
      return enum_for(__method__) unless block

      keys.each(&block)
      self
    end

    def require_group(path)
      path.split('/').reject(&:empty?).inject(self) do |parent, name|
        if parent.key?(name)
          child = parent[name]
          unless child.is_a?(Group)
            begin
              raise UnsupportedTypeError, "Existing object is not a group: #{name}"
            ensure
              Native.close_object(child)
            end
          end

          child
        else
          parent.create_group(name)
        end
      end
    end

    def open_dataset(name)
      object = self[name]
      unless object.is_a?(Dataset)
        begin
          raise UnsupportedTypeError, "Object is not a dataset: #{name}"
        ensure
          Native.close_object(object)
        end
      end
      return object unless block_given?

      begin
        yield object
      ensure
        Native.close_object(object)
      end
    end

    def key?(name)
      exists = HDF5::FFI.H5Lexists(hdf5_id, name, HDF5::DEFAULT_PROPERTY_LIST)
      raise NativeError, "Failed to check link existence: #{name}" if exists.negative?

      exists.positive?
    end

    def delete(name)
      status = HDF5::FFI.H5Ldelete(hdf5_id, name, HDF5::DEFAULT_PROPERTY_LIST)
      raise NativeError, "Failed to delete link: #{name}" if status < 0

      self
    end

    def create_hard_link(target, name)
      status = HDF5::FFI.H5Lcreate_hard(hdf5_id, target, hdf5_id, name, HDF5::DEFAULT_PROPERTY_LIST,
                                        HDF5::DEFAULT_PROPERTY_LIST)
      raise NativeError, "Failed to create hard link: #{name}" if status < 0

      self
    end

    def create_soft_link(target, name)
      status = HDF5::FFI.H5Lcreate_soft(target, hdf5_id, name, HDF5::DEFAULT_PROPERTY_LIST,
                                        HDF5::DEFAULT_PROPERTY_LIST)
      raise NativeError, "Failed to create soft link: #{name}" if status < 0

      self
    end

    def link_info(name)
      info = HDF5::FFI::MiV == 10 ? HDF5::FFI::H5LInfoT.new : HDF5::FFI::H5LInfo2T.new
      status = if HDF5::FFI::MiV == 10
                 HDF5::FFI.H5Lget_info(hdf5_id, name, info, HDF5::DEFAULT_PROPERTY_LIST)
               else
                 HDF5::FFI.H5Lget_info2(hdf5_id, name, info, HDF5::DEFAULT_PROPERTY_LIST)
               end
      raise NativeError, "Failed to get link information: #{name}" if status < 0

      type = info[:type]
      return { type: :hard } if type == :H5L_TYPE_HARD

      size = info[:u][:val_size]
      buffer = ::FFI::MemoryPointer.new(:char, size)
      status = HDF5::FFI.H5Lget_val(hdf5_id, name, buffer, size, HDF5::DEFAULT_PROPERTY_LIST)
      raise NativeError, "Failed to get link value: #{name}" if status < 0

      raw = buffer.read_bytes(size)
      return { type: :soft, target: raw.delete_suffix("\0") } if type == :H5L_TYPE_SOFT

      if type == :H5L_TYPE_EXTERNAL
        filename, path = raw.byteslice(1..).split("\0", 2)
        return { type: :external, filename:, path: path&.delete_suffix("\0") }
      end

      raise UnsupportedTypeError, "Unsupported link type: #{type}"
    end

    def move(source, destination)
      status = HDF5::FFI.H5Lmove(hdf5_id, source, hdf5_id, destination, HDF5::DEFAULT_PROPERTY_LIST,
                                 HDF5::DEFAULT_PROPERTY_LIST)
      raise NativeError, "Failed to move link: #{source}" if status < 0

      self
    end

    prepend FileContext.guard(*(instance_methods(false) - %i[each_key open_dataset]))

    private

    def object_type(name)
      info = HDF5::FFI::MiV == 10 ? HDF5::FFI::H5OInfoT.new : HDF5::FFI::H5OInfo1T.new
      status = if HDF5::FFI::MiV == 10
                 HDF5::FFI.H5Oget_info_by_name(hdf5_id, name, info, HDF5::DEFAULT_PROPERTY_LIST)
               else
                 HDF5::FFI.H5Oget_info_by_name1(hdf5_id, name, info, HDF5::DEFAULT_PROPERTY_LIST)
               end
      Native.check(status, "Failed to inspect group or dataset: #{name}")
      info[:type]
    end
  end
end
