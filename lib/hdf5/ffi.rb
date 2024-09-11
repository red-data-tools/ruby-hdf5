module HDF5
  module FFI
    extend ::FFI::Library

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

    major_ptr = ::FFI::MemoryPointer.new(:int)
    minor_ptr = ::FFI::MemoryPointer.new(:int)
    release_ptr = ::FFI::MemoryPointer.new(:int)
    HDF5::FFI.H5get_libversion(major_ptr, minor_ptr, release_ptr)

    raise 'HDF5 major version mismatch' if major_ptr.read_int != 1

    case minor_ptr.read_int
    when 10
      require_relative 'ffi_10'
    when 14..Float::INFINITY
      require_relative 'ffi_14'
    end
  end
end
