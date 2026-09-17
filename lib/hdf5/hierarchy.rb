module HDF5
  module Hierarchy
    def keys
      list_entries
    end

    def key?(name)
      exists = HDF5::FFI.H5Lexists(hdf5_id, name, HDF5::DEFAULT_PROPERTY_LIST)
      raise HDF5::Error, "Failed to check link existence: #{name}" if exists.negative?

      exists.positive?
    end

    def delete(name)
      status = HDF5::FFI.H5Ldelete(hdf5_id, name, HDF5::DEFAULT_PROPERTY_LIST)
      raise HDF5::Error, "Failed to delete link: #{name}" if status < 0

      self
    end

    def move(source, destination)
      status = HDF5::FFI.H5Lmove(hdf5_id, source, hdf5_id, destination, HDF5::DEFAULT_PROPERTY_LIST,
                                 HDF5::DEFAULT_PROPERTY_LIST)
      raise HDF5::Error, "Failed to move link: #{source}" if status < 0

      self
    end
  end
end