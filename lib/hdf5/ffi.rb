module HDF5
  module FFI
    extend ::FFI::Library

    require 'monitor'

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
               in [1, 10..13]
                 'ffi_10'
               in [1, 14..]
                 'ffi_14'
               else
                 raise "Unsupported HDF5 version #{major}.#{minor}.#{release}"
               end

    require_relative @backend

    REQUIRED_FUNCTIONS = %i[
      H5Fopen H5Fcreate H5Fclose H5Fflush
      H5Gopen2 H5Gcreate2 H5Gclose
      H5Dopen2 H5Dcreate2 H5Dclose H5Dread H5Dwrite H5Dget_type H5Dget_space H5Dset_extent H5Dget_create_plist
      H5Aopen H5Acreate2 H5Aclose H5Aread H5Awrite H5Aexists H5Adelete H5Aiterate2 H5Aget_type H5Aget_space
      H5Screate H5Screate_simple H5Sclose H5Sget_simple_extent_type H5Sget_simple_extent_ndims
      H5Sget_simple_extent_dims H5Sselect_hyperslab H5Sget_select_npoints
      H5Tcopy H5Tclose H5Tget_class H5Tget_size H5Tget_sign H5Tget_order H5Tget_precision H5Tget_offset
      H5Tset_size H5Tset_cset H5Tis_variable_str H5Tcreate H5Tinsert H5Tenum_create H5Tenum_insert
      H5Tenum_valueof H5Tget_nmembers H5Tget_member_index H5Tget_member_offset H5Tget_member_type H5Tget_super
      H5Pcreate H5Pclose H5Pset_chunk H5Pget_chunk H5Pget_layout H5Pset_deflate H5Pset_shuffle H5Pset_fletcher32
      H5Pset_fill_value H5Pget_fill_value H5Zfilter_avail H5Zget_filter_info
      H5Lexists H5Ldelete H5Lmove H5Lcreate_hard H5Lcreate_soft H5Lget_val H5Dvlen_reclaim
    ].freeze
    version_functions = MiV == 10 ? %i[H5Literate H5Lget_info H5Oget_info_by_name] :
      %i[H5Literate2 H5Lget_info2 H5Oget_info_by_name1]
    missing = (REQUIRED_FUNCTIONS + version_functions).reject { |name| respond_to?(name) }
    raise LoadError, "Loaded HDF5 library is missing required APIs: #{missing.join(', ')}" unless missing.empty?

    CALL_LOCK = Monitor.new
    synchronized_calls = Module.new
    singleton_methods.grep(/^H5/).each do |name|
      synchronized_calls.define_method(name) do |*args, **kwargs, &block|
        CALL_LOCK.synchronize { super(*args, **kwargs, &block) }
      end
    end
    singleton_class.prepend(synchronized_calls)
  end
end
