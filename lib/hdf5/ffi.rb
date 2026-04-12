module HDF5
  module FFI
    extend ::FFI::Library

    class << self
      attr_reader :backend
    end

    begin
      ffi_lib HDF5.lib_path
    rescue LoadError => e
      raise LoadError, "#{e}\nCould not find #{HDF5.lib_path}"
    end

    # @!macro attach_function
    #   @!scope class
    #   @!method $1(${2--2})
    #   @return [${-1}] the return value of $0
    def self.attach_function(*)
      super
    rescue ::FFI::NotFoundError => e
      warn e.message # if $VERBOSE
    end

    def self.attach_variable(*)
      super
    rescue ::FFI::NotFoundError => e
      warn e.message # if $VERBOSE
    end

    attach_function 'H5get_libversion', %i[
      pointer
      pointer
      pointer
    ], :int

    major_ptr = ::FFI::MemoryPointer.new(:uint)
    minor_ptr = ::FFI::MemoryPointer.new(:uint)
    release_ptr = ::FFI::MemoryPointer.new(:uint)
    HDF5::FFI.H5get_libversion(major_ptr, minor_ptr, release_ptr)

    major = major_ptr.read_uint
    minor = minor_ptr.read_uint
    release = release_ptr.read_uint

    @backend = case [major, minor]
               in [1, 14..]
                 'ffi_14'
               in [2.., _]
                 'ffi_14'
               else
                 raise "Unsupported HDF5 version #{major}.#{minor}.#{release}"
               end

    require_relative @backend
  end
end
