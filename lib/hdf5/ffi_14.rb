# require_relative 'ffi'

module HDF5
  module FFI
    MiV = 14

    typedef :uchar, :__u_char

    typedef :ushort, :__u_short

    typedef :uint, :__u_int

    typedef :ulong, :__u_long

    typedef :char, :__int8_t

    typedef :uchar, :__uint8_t

    typedef :short, :__int16_t

    typedef :ushort, :__uint16_t

    typedef :int, :__int32_t

    typedef :uint, :__uint32_t

    typedef :long, :__int64_t

    typedef :ulong, :__uint64_t

    typedef :__int8_t, :__int_least8_t

    typedef :__uint8_t, :__uint_least8_t

    typedef :__int16_t, :__int_least16_t

    typedef :__uint16_t, :__uint_least16_t

    typedef :__int32_t, :__int_least32_t

    typedef :__uint32_t, :__uint_least32_t

    typedef :__int64_t, :__int_least64_t

    typedef :__uint64_t, :__uint_least64_t

    typedef :long, :__quad_t

    typedef :ulong, :__u_quad_t

    typedef :long, :__intmax_t

    typedef :ulong, :__uintmax_t

    typedef :ulong, :__dev_t

    typedef :uint, :__uid_t

    typedef :uint, :__gid_t

    typedef :ulong, :__ino_t

    typedef :ulong, :__ino64_t

    typedef :uint, :__mode_t

    typedef :ulong, :__nlink_t

    typedef :long, :__off_t

    typedef :long, :__off64_t

    typedef :int, :__pid_t

    class Anon_Type_1 < ::FFI::Struct
      layout \
        :__val, [:int, 2]
    end

    C_FsidT = Anon_Type_1

    typedef :long, :__clock_t

    typedef :ulong, :__rlim_t

    typedef :ulong, :__rlim64_t

    typedef :uint, :__id_t

    typedef :long, :__time_t

    typedef :uint, :__useconds_t

    typedef :long, :__suseconds_t

    typedef :long, :__suseconds64_t

    typedef :int, :__daddr_t

    typedef :int, :__key_t

    typedef :int, :__clockid_t

    typedef :pointer, :__timer_t

    typedef :long, :__blksize_t

    typedef :long, :__blkcnt_t

    typedef :long, :__blkcnt64_t

    typedef :ulong, :__fsblkcnt_t

    typedef :ulong, :__fsblkcnt64_t

    typedef :ulong, :__fsfilcnt_t

    typedef :ulong, :__fsfilcnt64_t

    typedef :long, :__fsword_t

    typedef :long, :__ssize_t

    typedef :long, :__syscall_slong_t

    typedef :ulong, :__syscall_ulong_t

    typedef :__off64_t, :__loff_t

    typedef :string, :__caddr_t

    typedef :long, :__intptr_t

    typedef :uint, :__socklen_t

    typedef :int, :__sig_atomic_t

    typedef :__int8_t, :int8_t

    typedef :__int16_t, :int16_t

    typedef :__int32_t, :int32_t

    typedef :__int64_t, :int64_t

    typedef :__uint8_t, :uint8_t

    typedef :__uint16_t, :uint16_t

    typedef :__uint32_t, :uint32_t

    typedef :__uint64_t, :uint64_t

    typedef :__int_least8_t, :int_least8_t

    typedef :__int_least16_t, :int_least16_t

    typedef :__int_least32_t, :int_least32_t

    typedef :__int_least64_t, :int_least64_t

    typedef :__uint_least8_t, :uint_least8_t

    typedef :__uint_least16_t, :uint_least16_t

    typedef :__uint_least32_t, :uint_least32_t

    typedef :__uint_least64_t, :uint_least64_t

    typedef :char, :int_fast8_t

    typedef :long, :int_fast16_t

    typedef :long, :int_fast32_t

    typedef :long, :int_fast64_t

    typedef :uchar, :uint_fast8_t

    typedef :ulong, :uint_fast16_t

    typedef :ulong, :uint_fast32_t

    typedef :ulong, :uint_fast64_t

    typedef :long, :intptr_t

    typedef :ulong, :uintptr_t

    typedef :__intmax_t, :intmax_t

    typedef :__uintmax_t, :uintmax_t

    typedef :int, :__gwchar_t

    class Anon_Type_2 < ::FFI::Struct
      layout \
        :quot, :long,
        :rem, :long
    end

    ImaxdivT = Anon_Type_2

    attach_function 'imaxabs', [
      :intmax_t
    ], :intmax_t

    attach_function 'imaxdiv', %i[
      intmax_t
      intmax_t
    ], ImaxdivT

    attach_function 'strtoimax', %i[
      string
      pointer
      int
    ], :intmax_t

    attach_function 'strtoumax', %i[
      string
      pointer
      int
    ], :uintmax_t

    attach_function 'wcstoimax', %i[
      pointer
      pointer
      int
    ], :intmax_t

    attach_function 'wcstoumax', %i[
      pointer
      pointer
      int
    ], :uintmax_t

    typedef :pointer, :va_list

    typedef :pointer, :__gnuc_va_list

    typedef :long, :ptrdiff_t

    typedef :ulong, :size_t

    typedef :int, :wchar_t

    class Anon_Type_3 < ::FFI::Struct
      layout \
        :__clang_max_align_nonce1, :long_long,
        :__clang_max_align_nonce2, :long_double
    end

    MaxAlignT = Anon_Type_3

    typedef :__u_char, :u_char

    typedef :__u_short, :u_short

    typedef :__u_int, :u_int

    typedef :__u_long, :u_long

    typedef :__quad_t, :quad_t

    typedef :__u_quad_t, :u_quad_t

    FsidT = C_FsidT

    typedef :__loff_t, :loff_t

    typedef :__ino_t, :ino_t

    typedef :__dev_t, :dev_t

    typedef :__gid_t, :gid_t

    typedef :__mode_t, :mode_t

    typedef :__nlink_t, :nlink_t

    typedef :__uid_t, :uid_t

    typedef :__off_t, :off_t

    typedef :__pid_t, :pid_t

    typedef :__id_t, :id_t

    typedef :__ssize_t, :ssize_t

    typedef :__daddr_t, :daddr_t

    typedef :__caddr_t, :caddr_t

    typedef :__key_t, :key_t

    typedef :__clock_t, :clock_t

    typedef :__clockid_t, :clockid_t

    typedef :__time_t, :time_t

    typedef :__timer_t, :timer_t

    typedef :ulong, :ulong

    typedef :ushort, :ushort

    typedef :uint, :uint

    typedef :__uint8_t, :u_int8_t

    typedef :__uint16_t, :u_int16_t

    typedef :__uint32_t, :u_int32_t

    typedef :__uint64_t, :u_int64_t

    typedef :int, :register_t

    # attach_function '__bswap_16', [
    #   :__uint16_t
    # ], :__uint16_t

    # attach_function '__bswap_32', [
    #   :__uint32_t
    # ], :__uint32_t

    # attach_function '__bswap_64', [
    #   :__uint64_t
    # ], :__uint64_t

    # attach_function '__uint16_identity', [
    #   :__uint16_t
    # ], :__uint16_t

    # attach_function '__uint32_identity', [
    #   :__uint32_t
    # ], :__uint32_t

    # attach_function '__uint64_identity', [
    #   :__uint64_t
    # ], :__uint64_t

    class Anon_Type_4 < ::FFI::Struct
      layout \
        :__val, [:ulong, 16]
    end

    C_SigsetT = Anon_Type_4

    SigsetT = C_SigsetT

    class Timeval < ::FFI::Struct
      layout \
        :tv_sec, :__time_t,
        :tv_usec, :__suseconds_t
    end

    class Timespec < ::FFI::Struct
      layout \
        :tv_sec, :__time_t,
        :tv_nsec, :__syscall_slong_t
    end

    typedef :__suseconds_t, :suseconds_t

    typedef :long, :__fd_mask

    class Anon_Type_5 < ::FFI::Struct
      layout \
        :__fds_bits, [:__fd_mask, 16]
    end

    FdSet = Anon_Type_5

    typedef :__fd_mask, :fd_mask

    attach_function 'select', [
      :int,
      FdSet.ptr,
      FdSet.ptr,
      FdSet.ptr,
      Timeval.ptr
    ], :int

    attach_function 'pselect', [
      :int,
      FdSet.ptr,
      FdSet.ptr,
      FdSet.ptr,
      Timespec.ptr,
      C_SigsetT.ptr
    ], :int

    typedef :__blksize_t, :blksize_t

    typedef :__blkcnt_t, :blkcnt_t

    typedef :__fsblkcnt_t, :fsblkcnt_t

    typedef :__fsfilcnt_t, :fsfilcnt_t

    class Anon_Type_7 < ::FFI::Struct
      layout \
        :__low, :uint,
        :__high, :uint
    end

    class Anon_Type_6 < ::FFI::Union
      layout \
        :__value64, :ulong_long,
        :__value32, Anon_Type_7
    end

    C_AtomicWideCounter = Anon_Type_6

    class C_PthreadInternalList < ::FFI::Struct
      layout \
        :__prev, C_PthreadInternalList.ptr,
        :__next, C_PthreadInternalList.ptr
    end

    C_PthreadListT = C_PthreadInternalList

    class C_PthreadInternalSlist < ::FFI::Struct
      layout \
        :__next, C_PthreadInternalSlist.ptr
    end

    C_PthreadSlistT = C_PthreadInternalSlist

    class C_PthreadMutexS < ::FFI::Struct
      layout \
        :__lock, :int,
        :__count, :uint,
        :__owner, :int,
        :__nusers, :uint,
        :__kind, :int,
        :__spins, :short,
        :__elision, :short,
        :__list, C_PthreadListT
    end

    class C_PthreadRwlockArchT < ::FFI::Struct
      layout \
        :__readers, :uint,
        :__writers, :uint,
        :__wrphase_futex, :uint,
        :__writers_futex, :uint,
        :__pad3, :uint,
        :__pad4, :uint,
        :__cur_writer, :int,
        :__shared, :int,
        :__rwelision, :char,
        :__pad1, [:uchar, 7],
        :__pad2, :ulong,
        :__flags, :uint
    end

    class C_PthreadCondS < ::FFI::Struct
      layout \
        :__wseq, C_AtomicWideCounter,
        :__g1_start, C_AtomicWideCounter,
        :__g_refs, [:uint, 2],
        :__g_size, [:uint, 2],
        :__g1_orig_size, :uint,
        :__wrefs, :uint,
        :__g_signals, [:uint, 2]
    end

    typedef :uint, :__tss_t

    typedef :ulong, :__thrd_t

    class Anon_Type_8 < ::FFI::Struct
      layout \
        :__data, :int
    end

    C_OnceFlag = Anon_Type_8

    typedef :ulong, :pthread_t

    class Anon_Type_9 < ::FFI::Union
      layout \
        :__size, [:char, 4],
        :__align, :int
    end

    PthreadMutexattrT = Anon_Type_9

    class Anon_Type_10 < ::FFI::Union
      layout \
        :__size, [:char, 4],
        :__align, :int
    end

    PthreadCondattrT = Anon_Type_10

    typedef :uint, :pthread_key_t

    typedef :int, :pthread_once_t

    class PthreadAttrT < ::FFI::Union
      layout \
        :__size, [:char, 56],
        :__align, :long
    end

    # PthreadAttrT = PthreadAttrT

    class Anon_Type_11 < ::FFI::Union
      layout \
        :__data, C_PthreadMutexS,
        :__size, [:char, 40],
        :__align, :long
    end

    PthreadMutexT = Anon_Type_11

    class Anon_Type_12 < ::FFI::Union
      layout \
        :__data, C_PthreadCondS,
        :__size, [:char, 48],
        :__align, :long_long
    end

    PthreadCondT = Anon_Type_12

    class Anon_Type_13 < ::FFI::Union
      layout \
        :__data, C_PthreadRwlockArchT,
        :__size, [:char, 56],
        :__align, :long
    end

    PthreadRwlockT = Anon_Type_13

    class Anon_Type_14 < ::FFI::Union
      layout \
        :__size, [:char, 8],
        :__align, :long
    end

    PthreadRwlockattrT = Anon_Type_14

    typedef :int, :pthread_spinlock_t

    class Anon_Type_15 < ::FFI::Union
      layout \
        :__size, [:char, 32],
        :__align, :long
    end

    PthreadBarrierT = Anon_Type_15

    class Anon_Type_16 < ::FFI::Union
      layout \
        :__size, [:char, 4],
        :__align, :int
    end

    PthreadBarrierattrT = Anon_Type_16

    typedef :int, :herr_t

    typedef :bool, :hbool_t

    typedef :int, :htri_t

    typedef :uint64_t, :hsize_t

    typedef :int64_t, :hssize_t

    typedef :uint64_t, :haddr_t

    enum :anon_enum_25, [
      :H5_ITER_UNKNOWN, 4_294_967_295,
      :H5_ITER_INC, 0,
      :H5_ITER_DEC, 1,
      :H5_ITER_NATIVE, 2,
      :H5_ITER_N, 3
    ]

    typedef :anon_enum_25, :H5_iter_order_t

    enum :H5_index_t, [
      :H5_INDEX_UNKNOWN, 4_294_967_295,
      :H5_INDEX_NAME, 0,
      :H5_INDEX_CRT_ORDER, 1,
      :H5_INDEX_N, 2
    ]

    typedef :H5_index_t, :H5_index_t

    class H5IhInfoT < ::FFI::Struct
      layout \
        :index_size, :hsize_t,
        :heap_size, :hsize_t
    end

    # H5IhInfoT = H5IhInfoT

    class H5OTokenT < ::FFI::Struct
      layout \
        :__data, [:uint8_t, 16]
    end

    # H5OTokenT = H5OTokenT

    typedef :pointer, :H5_atclose_func_t

    attach_function 'H5open', [], :herr_t

    attach_function 'H5atclose', %i[
      H5_atclose_func_t
      pointer
    ], :herr_t

    attach_function 'H5close', [], :herr_t

    attach_function 'H5dont_atexit', [], :herr_t

    attach_function 'H5garbage_collect', [], :herr_t

    attach_function 'H5set_free_list_limits', %i[
      int
      int
      int
      int
      int
      int
    ], :herr_t

    attach_function 'H5get_free_list_sizes', %i[
      pointer
      pointer
      pointer
      pointer
    ], :herr_t

    # attach_function 'H5get_libversion', %i[
    #   pointer
    #   pointer
    #   pointer
    # ], :herr_t

    attach_function 'H5check_version', %i[
      uint
      uint
      uint
    ], :herr_t

    attach_function 'H5is_library_terminating', [
      :pointer
    ], :herr_t

    attach_function 'H5is_library_threadsafe', [
      :pointer
    ], :herr_t

    attach_function 'H5free_memory', [
      :pointer
    ], :herr_t

    attach_function 'H5allocate_memory', %i[
      size_t
      hbool_t
    ], :pointer

    attach_function 'H5resize_memory', %i[
      pointer
      size_t
    ], :pointer

    enum :H5I_type_t, [
      :H5I_UNINIT, 4_294_967_294,
      :H5I_BADID, 4_294_967_295,
      :H5I_FILE, 1,
      :H5I_GROUP, 2,
      :H5I_DATATYPE, 3,
      :H5I_DATASPACE, 4,
      :H5I_DATASET, 5,
      :H5I_MAP, 6,
      :H5I_ATTR, 7,
      :H5I_VFL, 8,
      :H5I_VOL, 9,
      :H5I_GENPROP_CLS, 10,
      :H5I_GENPROP_LST, 11,
      :H5I_ERROR_CLASS, 12,
      :H5I_ERROR_MSG, 13,
      :H5I_ERROR_STACK, 14,
      :H5I_SPACE_SEL_ITER, 15,
      :H5I_EVENTSET, 16,
      :H5I_NTYPES, 17
    ]

    typedef :H5I_type_t, :H5I_type_t

    typedef :int64_t, :hid_t

    typedef :pointer, :H5I_free_t

    typedef :pointer, :H5I_search_func_t

    typedef :pointer, :H5I_iterate_func_t

    attach_function 'H5Iregister', %i[
      H5I_type_t
      pointer
    ], :hid_t

    attach_function 'H5Iobject_verify', %i[
      hid_t
      H5I_type_t
    ], :pointer

    attach_function 'H5Iremove_verify', %i[
      hid_t
      H5I_type_t
    ], :pointer

    attach_function 'H5Iget_type', [
      :hid_t
    ], :H5I_type_t

    attach_function 'H5Iget_file_id', [
      :hid_t
    ], :hid_t

    attach_function 'H5Iget_name', %i[
      hid_t
      string
      size_t
    ], :ssize_t

    attach_function 'H5Iinc_ref', [
      :hid_t
    ], :int

    attach_function 'H5Idec_ref', [
      :hid_t
    ], :int

    attach_function 'H5Iget_ref', [
      :hid_t
    ], :int

    attach_function 'H5Iregister_type', %i[
      size_t
      uint
      H5I_free_t
    ], :H5I_type_t

    attach_function 'H5Iclear_type', %i[
      H5I_type_t
      hbool_t
    ], :herr_t

    attach_function 'H5Idestroy_type', [
      :H5I_type_t
    ], :herr_t

    attach_function 'H5Iinc_type_ref', [
      :H5I_type_t
    ], :int

    attach_function 'H5Idec_type_ref', [
      :H5I_type_t
    ], :int

    attach_function 'H5Iget_type_ref', [
      :H5I_type_t
    ], :int

    attach_function 'H5Isearch', %i[
      H5I_type_t
      H5I_search_func_t
      pointer
    ], :pointer

    attach_function 'H5Iiterate', %i[
      H5I_type_t
      H5I_iterate_func_t
      pointer
    ], :herr_t

    attach_function 'H5Inmembers', %i[
      H5I_type_t
      pointer
    ], :herr_t

    attach_function 'H5Itype_exists', [
      :H5I_type_t
    ], :htri_t

    attach_function 'H5Iis_valid', [
      :hid_t
    ], :htri_t

    enum :H5O_type_t, [
      :H5O_TYPE_UNKNOWN, 4_294_967_295,
      :H5O_TYPE_GROUP, 0,
      :H5O_TYPE_DATASET, 1,
      :H5O_TYPE_NAMED_DATATYPE, 2,
      :H5O_TYPE_MAP, 3,
      :H5O_TYPE_NTYPES, 4
    ]

    typedef :H5O_type_t, :H5O_type_t

    class Anon_Type_17 < ::FFI::Struct
      layout \
        :total, :hsize_t,
        :meta, :hsize_t,
        :mesg, :hsize_t,
        :free, :hsize_t
    end

    class Anon_Type_18 < ::FFI::Struct
      layout \
        :present, :uint64_t,
        :shared, :uint64_t
    end

    class H5OHdrInfoT < ::FFI::Struct
      layout \
        :version, :uint,
        :nmesgs, :uint,
        :nchunks, :uint,
        :flags, :uint,
        :space, Anon_Type_17,
        :mesg, Anon_Type_18
    end

    # H5OHdrInfoT = H5OHdrInfoT

    class H5OInfo2T < ::FFI::Struct
      layout \
        :fileno, :ulong,
        :token, H5OTokenT,
        :type, :H5O_type_t,
        :rc, :uint,
        :atime, :time_t,
        :mtime, :time_t,
        :ctime, :time_t,
        :btime, :time_t,
        :num_attrs, :hsize_t
    end

    # H5OInfo2T = H5OInfo2T

    class Anon_Type_19 < ::FFI::Struct
      layout \
        :obj, H5IhInfoT,
        :attr, H5IhInfoT
    end

    class H5ONativeInfoT < ::FFI::Struct
      layout \
        :hdr, H5OHdrInfoT,
        :meta_size, Anon_Type_19
    end

    # H5ONativeInfoT = H5ONativeInfoT

    typedef :uint32_t, :H5O_msg_crt_idx_t

    typedef :pointer, :H5O_iterate2_t

    enum :H5O_mcdt_search_ret_t, [
      :H5O_MCDT_SEARCH_ERROR, 4_294_967_295,
      :H5O_MCDT_SEARCH_CONT, 0,
      :H5O_MCDT_SEARCH_STOP, 1
    ]

    typedef :H5O_mcdt_search_ret_t, :H5O_mcdt_search_ret_t

    typedef :pointer, :H5O_mcdt_search_cb_t

    attach_function 'H5Oopen', %i[
      hid_t
      string
      hid_t
    ], :hid_t

    attach_function 'H5Oopen_async', %i[
      string
      string
      uint
      hid_t
      string
      hid_t
      hid_t
    ], :hid_t

    attach_function 'H5Oopen_by_token', [
      :hid_t,
      H5OTokenT
    ], :hid_t

    attach_function 'H5Oopen_by_idx', %i[
      hid_t
      string
      H5_index_t
      H5_iter_order_t
      hsize_t
      hid_t
    ], :hid_t

    attach_function 'H5Oopen_by_idx_async', %i[
      string
      string
      uint
      hid_t
      string
      H5_index_t
      H5_iter_order_t
      hsize_t
      hid_t
      hid_t
    ], :hid_t

    attach_function 'H5Oexists_by_name', %i[
      hid_t
      string
      hid_t
    ], :htri_t

    attach_function 'H5Oget_info3', [
      :hid_t,
      H5OInfo2T.ptr,
      :uint
    ], :herr_t

    attach_function 'H5Oget_info_by_name3', [
      :hid_t,
      :string,
      H5OInfo2T.ptr,
      :uint,
      :hid_t
    ], :herr_t

    attach_function 'H5Oget_info_by_name_async', [
      :string,
      :string,
      :uint,
      :hid_t,
      :string,
      H5OInfo2T.ptr,
      :uint,
      :hid_t,
      :hid_t
    ], :herr_t

    attach_function 'H5Oget_info_by_idx3', [
      :hid_t,
      :string,
      :H5_index_t,
      :H5_iter_order_t,
      :hsize_t,
      H5OInfo2T.ptr,
      :uint,
      :hid_t
    ], :herr_t

    attach_function 'H5Oget_native_info', [
      :hid_t,
      H5ONativeInfoT.ptr,
      :uint
    ], :herr_t

    attach_function 'H5Oget_native_info_by_name', [
      :hid_t,
      :string,
      H5ONativeInfoT.ptr,
      :uint,
      :hid_t
    ], :herr_t

    attach_function 'H5Oget_native_info_by_idx', [
      :hid_t,
      :string,
      :H5_index_t,
      :H5_iter_order_t,
      :hsize_t,
      H5ONativeInfoT.ptr,
      :uint,
      :hid_t
    ], :herr_t

    attach_function 'H5Olink', %i[
      hid_t
      hid_t
      string
      hid_t
      hid_t
    ], :herr_t

    attach_function 'H5Oincr_refcount', [
      :hid_t
    ], :herr_t

    attach_function 'H5Odecr_refcount', [
      :hid_t
    ], :herr_t

    attach_function 'H5Ocopy', %i[
      hid_t
      string
      hid_t
      string
      hid_t
      hid_t
    ], :herr_t

    attach_function 'H5Ocopy_async', %i[
      string
      string
      uint
      hid_t
      string
      hid_t
      string
      hid_t
      hid_t
      hid_t
    ], :herr_t

    attach_function 'H5Oset_comment', %i[
      hid_t
      string
    ], :herr_t

    attach_function 'H5Oset_comment_by_name', %i[
      hid_t
      string
      string
      hid_t
    ], :herr_t

    attach_function 'H5Oget_comment', %i[
      hid_t
      string
      size_t
    ], :ssize_t

    attach_function 'H5Oget_comment_by_name', %i[
      hid_t
      string
      string
      size_t
      hid_t
    ], :ssize_t

    attach_function 'H5Ovisit3', %i[
      hid_t
      H5_index_t
      H5_iter_order_t
      H5O_iterate2_t
      pointer
      uint
    ], :herr_t

    attach_function 'H5Ovisit_by_name3', %i[
      hid_t
      string
      H5_index_t
      H5_iter_order_t
      H5O_iterate2_t
      pointer
      uint
      hid_t
    ], :herr_t

    attach_function 'H5Oclose', [
      :hid_t
    ], :herr_t

    attach_function 'H5Oclose_async', %i[
      string
      string
      uint
      hid_t
      hid_t
    ], :herr_t

    attach_function 'H5Oflush', [
      :hid_t
    ], :herr_t

    attach_function 'H5Oflush_async', %i[
      string
      string
      uint
      hid_t
      hid_t
    ], :herr_t

    attach_function 'H5Orefresh', [
      :hid_t
    ], :herr_t

    attach_function 'H5Orefresh_async', %i[
      string
      string
      uint
      hid_t
      hid_t
    ], :herr_t

    attach_function 'H5Odisable_mdc_flushes', [
      :hid_t
    ], :herr_t

    attach_function 'H5Oenable_mdc_flushes', [
      :hid_t
    ], :herr_t

    attach_function 'H5Oare_mdc_flushes_disabled', %i[
      hid_t
      pointer
    ], :herr_t

    attach_function 'H5Otoken_cmp', [
      :hid_t,
      H5OTokenT.ptr,
      H5OTokenT.ptr,
      :pointer
    ], :herr_t

    attach_function 'H5Otoken_to_str', [
      :hid_t,
      H5OTokenT.ptr,
      :pointer
    ], :herr_t

    attach_function 'H5Otoken_from_str', [
      :hid_t,
      :string,
      H5OTokenT.ptr
    ], :herr_t

    attach_variable :H5O_TOKEN_UNDEF_g, :H5O_TOKEN_UNDEF_g, H5OTokenT

    class H5OStatT < ::FFI::Struct
      layout \
        :size, :hsize_t,
        :free, :hsize_t,
        :nmesgs, :uint,
        :nchunks, :uint
    end

    # H5OStatT = H5OStatT

    class Anon_Type_20 < ::FFI::Struct
      layout \
        :obj, H5IhInfoT,
        :attr, H5IhInfoT
    end

    class H5OInfo1T < ::FFI::Struct
      layout \
        :fileno, :ulong,
        :addr, :haddr_t,
        :type, :H5O_type_t,
        :rc, :uint,
        :atime, :time_t,
        :mtime, :time_t,
        :ctime, :time_t,
        :btime, :time_t,
        :num_attrs, :hsize_t,
        :hdr, H5OHdrInfoT,
        :meta_size, Anon_Type_20
    end

    # H5OInfo1T = H5OInfo1T

    typedef :pointer, :H5O_iterate1_t

    attach_function 'H5Oopen_by_addr', %i[
      hid_t
      haddr_t
    ], :hid_t

    attach_function 'H5Oget_info1', [
      :hid_t,
      H5OInfo1T.ptr
    ], :herr_t

    attach_function 'H5Oget_info_by_name1', [
      :hid_t,
      :string,
      H5OInfo1T.ptr,
      :hid_t
    ], :herr_t

    attach_function 'H5Oget_info_by_idx1', [
      :hid_t,
      :string,
      :H5_index_t,
      :H5_iter_order_t,
      :hsize_t,
      H5OInfo1T.ptr,
      :hid_t
    ], :herr_t

    attach_function 'H5Oget_info2', [
      :hid_t,
      H5OInfo1T.ptr,
      :uint
    ], :herr_t

    attach_function 'H5Oget_info_by_name2', [
      :hid_t,
      :string,
      H5OInfo1T.ptr,
      :uint,
      :hid_t
    ], :herr_t

    attach_function 'H5Oget_info_by_idx2', [
      :hid_t,
      :string,
      :H5_index_t,
      :H5_iter_order_t,
      :hsize_t,
      H5OInfo1T.ptr,
      :uint,
      :hid_t
    ], :herr_t

    attach_function 'H5Ovisit1', %i[
      hid_t
      H5_index_t
      H5_iter_order_t
      H5O_iterate1_t
      pointer
    ], :herr_t

    attach_function 'H5Ovisit_by_name1', %i[
      hid_t
      string
      H5_index_t
      H5_iter_order_t
      H5O_iterate1_t
      pointer
      hid_t
    ], :herr_t

    attach_function 'H5Ovisit2', %i[
      hid_t
      H5_index_t
      H5_iter_order_t
      H5O_iterate1_t
      pointer
      uint
    ], :herr_t

    attach_function 'H5Ovisit_by_name2', %i[
      hid_t
      string
      H5_index_t
      H5_iter_order_t
      H5O_iterate1_t
      pointer
      uint
      hid_t
    ], :herr_t

    enum :H5T_class_t, [
      :H5T_NO_CLASS, 4_294_967_295,
      :H5T_INTEGER, 0,
      :H5T_FLOAT, 1,
      :H5T_TIME, 2,
      :H5T_STRING, 3,
      :H5T_BITFIELD, 4,
      :H5T_OPAQUE, 5,
      :H5T_COMPOUND, 6,
      :H5T_REFERENCE, 7,
      :H5T_ENUM, 8,
      :H5T_VLEN, 9,
      :H5T_ARRAY, 10,
      :H5T_NCLASSES, 11
    ]

    typedef :H5T_class_t, :H5T_class_t

    enum :H5T_order_t, [
      :H5T_ORDER_ERROR, 4_294_967_295,
      :H5T_ORDER_LE, 0,
      :H5T_ORDER_BE, 1,
      :H5T_ORDER_VAX, 2,
      :H5T_ORDER_MIXED, 3,
      :H5T_ORDER_NONE, 4
    ]

    typedef :H5T_order_t, :H5T_order_t

    enum :H5T_sign_t, [
      :H5T_SGN_ERROR, 4_294_967_295,
      :H5T_SGN_NONE, 0,
      :H5T_SGN_2, 1,
      :H5T_NSGN, 2
    ]

    typedef :H5T_sign_t, :H5T_sign_t

    enum :H5T_norm_t, [
      :H5T_NORM_ERROR, 4_294_967_295,
      :H5T_NORM_IMPLIED, 0,
      :H5T_NORM_MSBSET, 1,
      :H5T_NORM_NONE, 2
    ]

    typedef :H5T_norm_t, :H5T_norm_t

    enum :H5T_cset_t, [
      :H5T_CSET_ERROR, 4_294_967_295,
      :H5T_CSET_ASCII, 0,
      :H5T_CSET_UTF8, 1,
      :H5T_CSET_RESERVED_2, 2,
      :H5T_CSET_RESERVED_3, 3,
      :H5T_CSET_RESERVED_4, 4,
      :H5T_CSET_RESERVED_5, 5,
      :H5T_CSET_RESERVED_6, 6,
      :H5T_CSET_RESERVED_7, 7,
      :H5T_CSET_RESERVED_8, 8,
      :H5T_CSET_RESERVED_9, 9,
      :H5T_CSET_RESERVED_10, 10,
      :H5T_CSET_RESERVED_11, 11,
      :H5T_CSET_RESERVED_12, 12,
      :H5T_CSET_RESERVED_13, 13,
      :H5T_CSET_RESERVED_14, 14,
      :H5T_CSET_RESERVED_15, 15
    ]

    typedef :H5T_cset_t, :H5T_cset_t

    enum :H5T_str_t, [
      :H5T_STR_ERROR, 4_294_967_295,
      :H5T_STR_NULLTERM, 0,
      :H5T_STR_NULLPAD, 1,
      :H5T_STR_SPACEPAD, 2,
      :H5T_STR_RESERVED_3, 3,
      :H5T_STR_RESERVED_4, 4,
      :H5T_STR_RESERVED_5, 5,
      :H5T_STR_RESERVED_6, 6,
      :H5T_STR_RESERVED_7, 7,
      :H5T_STR_RESERVED_8, 8,
      :H5T_STR_RESERVED_9, 9,
      :H5T_STR_RESERVED_10, 10,
      :H5T_STR_RESERVED_11, 11,
      :H5T_STR_RESERVED_12, 12,
      :H5T_STR_RESERVED_13, 13,
      :H5T_STR_RESERVED_14, 14,
      :H5T_STR_RESERVED_15, 15
    ]

    typedef :H5T_str_t, :H5T_str_t

    enum :H5T_pad_t, [
      :H5T_PAD_ERROR, 4_294_967_295,
      :H5T_PAD_ZERO, 0,
      :H5T_PAD_ONE, 1,
      :H5T_PAD_BACKGROUND, 2,
      :H5T_NPAD, 3
    ]

    typedef :H5T_pad_t, :H5T_pad_t

    enum :H5T_direction_t, [
      :H5T_DIR_DEFAULT, 0,
      :H5T_DIR_ASCEND, 1,
      :H5T_DIR_DESCEND, 2
    ]

    typedef :H5T_direction_t, :H5T_direction_t

    enum :H5T_conv_except_t, [
      :H5T_CONV_EXCEPT_RANGE_HI, 0,
      :H5T_CONV_EXCEPT_RANGE_LOW, 1,
      :H5T_CONV_EXCEPT_PRECISION, 2,
      :H5T_CONV_EXCEPT_TRUNCATE, 3,
      :H5T_CONV_EXCEPT_PINF, 4,
      :H5T_CONV_EXCEPT_NINF, 5,
      :H5T_CONV_EXCEPT_NAN, 6
    ]

    typedef :H5T_conv_except_t, :H5T_conv_except_t

    enum :H5T_conv_ret_t, [
      :H5T_CONV_ABORT, 4_294_967_295,
      :H5T_CONV_UNHANDLED, 0,
      :H5T_CONV_HANDLED, 1
    ]

    typedef :H5T_conv_ret_t, :H5T_conv_ret_t

    class Anon_Type_21 < ::FFI::Struct
      layout \
        :len, :size_t,
        :p, :pointer
    end

    HvlT = Anon_Type_21

    typedef :pointer, :H5T_conv_except_func_t

    attach_variable :H5T_IEEE_F16BE_g, :H5T_IEEE_F16BE_g, :hid_t

    attach_variable :H5T_IEEE_F16LE_g, :H5T_IEEE_F16LE_g, :hid_t

    attach_variable :H5T_IEEE_F32BE_g, :H5T_IEEE_F32BE_g, :hid_t

    attach_variable :H5T_IEEE_F32LE_g, :H5T_IEEE_F32LE_g, :hid_t

    attach_variable :H5T_IEEE_F64BE_g, :H5T_IEEE_F64BE_g, :hid_t

    attach_variable :H5T_IEEE_F64LE_g, :H5T_IEEE_F64LE_g, :hid_t

    attach_variable :H5T_STD_I8BE_g, :H5T_STD_I8BE_g, :hid_t

    attach_variable :H5T_STD_I8LE_g, :H5T_STD_I8LE_g, :hid_t

    attach_variable :H5T_STD_I16BE_g, :H5T_STD_I16BE_g, :hid_t

    attach_variable :H5T_STD_I16LE_g, :H5T_STD_I16LE_g, :hid_t

    attach_variable :H5T_STD_I32BE_g, :H5T_STD_I32BE_g, :hid_t

    attach_variable :H5T_STD_I32LE_g, :H5T_STD_I32LE_g, :hid_t

    attach_variable :H5T_STD_I64BE_g, :H5T_STD_I64BE_g, :hid_t

    attach_variable :H5T_STD_I64LE_g, :H5T_STD_I64LE_g, :hid_t

    attach_variable :H5T_STD_U8BE_g, :H5T_STD_U8BE_g, :hid_t

    attach_variable :H5T_STD_U8LE_g, :H5T_STD_U8LE_g, :hid_t

    attach_variable :H5T_STD_U16BE_g, :H5T_STD_U16BE_g, :hid_t

    attach_variable :H5T_STD_U16LE_g, :H5T_STD_U16LE_g, :hid_t

    attach_variable :H5T_STD_U32BE_g, :H5T_STD_U32BE_g, :hid_t

    attach_variable :H5T_STD_U32LE_g, :H5T_STD_U32LE_g, :hid_t

    attach_variable :H5T_STD_U64BE_g, :H5T_STD_U64BE_g, :hid_t

    attach_variable :H5T_STD_U64LE_g, :H5T_STD_U64LE_g, :hid_t

    attach_variable :H5T_STD_B8BE_g, :H5T_STD_B8BE_g, :hid_t

    attach_variable :H5T_STD_B8LE_g, :H5T_STD_B8LE_g, :hid_t

    attach_variable :H5T_STD_B16BE_g, :H5T_STD_B16BE_g, :hid_t

    attach_variable :H5T_STD_B16LE_g, :H5T_STD_B16LE_g, :hid_t

    attach_variable :H5T_STD_B32BE_g, :H5T_STD_B32BE_g, :hid_t

    attach_variable :H5T_STD_B32LE_g, :H5T_STD_B32LE_g, :hid_t

    attach_variable :H5T_STD_B64BE_g, :H5T_STD_B64BE_g, :hid_t

    attach_variable :H5T_STD_B64LE_g, :H5T_STD_B64LE_g, :hid_t

    attach_variable :H5T_STD_REF_OBJ_g, :H5T_STD_REF_OBJ_g, :hid_t

    attach_variable :H5T_STD_REF_DSETREG_g, :H5T_STD_REF_DSETREG_g, :hid_t

    attach_variable :H5T_STD_REF_g, :H5T_STD_REF_g, :hid_t

    attach_variable :H5T_UNIX_D32BE_g, :H5T_UNIX_D32BE_g, :hid_t

    attach_variable :H5T_UNIX_D32LE_g, :H5T_UNIX_D32LE_g, :hid_t

    attach_variable :H5T_UNIX_D64BE_g, :H5T_UNIX_D64BE_g, :hid_t

    attach_variable :H5T_UNIX_D64LE_g, :H5T_UNIX_D64LE_g, :hid_t

    attach_variable :H5T_C_S1_g, :H5T_C_S1_g, :hid_t

    attach_variable :H5T_FORTRAN_S1_g, :H5T_FORTRAN_S1_g, :hid_t

    attach_variable :H5T_VAX_F32_g, :H5T_VAX_F32_g, :hid_t

    attach_variable :H5T_VAX_F64_g, :H5T_VAX_F64_g, :hid_t

    attach_variable :H5T_NATIVE_SCHAR_g, :H5T_NATIVE_SCHAR_g, :hid_t

    attach_variable :H5T_NATIVE_UCHAR_g, :H5T_NATIVE_UCHAR_g, :hid_t

    attach_variable :H5T_NATIVE_SHORT_g, :H5T_NATIVE_SHORT_g, :hid_t

    attach_variable :H5T_NATIVE_USHORT_g, :H5T_NATIVE_USHORT_g, :hid_t

    attach_variable :H5T_NATIVE_INT_g, :H5T_NATIVE_INT_g, :hid_t

    attach_variable :H5T_NATIVE_UINT_g, :H5T_NATIVE_UINT_g, :hid_t

    attach_variable :H5T_NATIVE_LONG_g, :H5T_NATIVE_LONG_g, :hid_t

    attach_variable :H5T_NATIVE_ULONG_g, :H5T_NATIVE_ULONG_g, :hid_t

    attach_variable :H5T_NATIVE_LLONG_g, :H5T_NATIVE_LLONG_g, :hid_t

    attach_variable :H5T_NATIVE_ULLONG_g, :H5T_NATIVE_ULLONG_g, :hid_t

    attach_variable :H5T_NATIVE_FLOAT16_g, :H5T_NATIVE_FLOAT16_g, :hid_t

    attach_variable :H5T_NATIVE_FLOAT_g, :H5T_NATIVE_FLOAT_g, :hid_t

    attach_variable :H5T_NATIVE_DOUBLE_g, :H5T_NATIVE_DOUBLE_g, :hid_t

    attach_variable :H5T_NATIVE_LDOUBLE_g, :H5T_NATIVE_LDOUBLE_g, :hid_t

    attach_variable :H5T_NATIVE_B8_g, :H5T_NATIVE_B8_g, :hid_t

    attach_variable :H5T_NATIVE_B16_g, :H5T_NATIVE_B16_g, :hid_t

    attach_variable :H5T_NATIVE_B32_g, :H5T_NATIVE_B32_g, :hid_t

    attach_variable :H5T_NATIVE_B64_g, :H5T_NATIVE_B64_g, :hid_t

    attach_variable :H5T_NATIVE_OPAQUE_g, :H5T_NATIVE_OPAQUE_g, :hid_t

    attach_variable :H5T_NATIVE_HADDR_g, :H5T_NATIVE_HADDR_g, :hid_t

    attach_variable :H5T_NATIVE_HSIZE_g, :H5T_NATIVE_HSIZE_g, :hid_t

    attach_variable :H5T_NATIVE_HSSIZE_g, :H5T_NATIVE_HSSIZE_g, :hid_t

    attach_variable :H5T_NATIVE_HERR_g, :H5T_NATIVE_HERR_g, :hid_t

    attach_variable :H5T_NATIVE_HBOOL_g, :H5T_NATIVE_HBOOL_g, :hid_t

    attach_variable :H5T_NATIVE_INT8_g, :H5T_NATIVE_INT8_g, :hid_t

    attach_variable :H5T_NATIVE_UINT8_g, :H5T_NATIVE_UINT8_g, :hid_t

    attach_variable :H5T_NATIVE_INT_LEAST8_g, :H5T_NATIVE_INT_LEAST8_g, :hid_t

    attach_variable :H5T_NATIVE_UINT_LEAST8_g, :H5T_NATIVE_UINT_LEAST8_g, :hid_t

    attach_variable :H5T_NATIVE_INT_FAST8_g, :H5T_NATIVE_INT_FAST8_g, :hid_t

    attach_variable :H5T_NATIVE_UINT_FAST8_g, :H5T_NATIVE_UINT_FAST8_g, :hid_t

    attach_variable :H5T_NATIVE_INT16_g, :H5T_NATIVE_INT16_g, :hid_t

    attach_variable :H5T_NATIVE_UINT16_g, :H5T_NATIVE_UINT16_g, :hid_t

    attach_variable :H5T_NATIVE_INT_LEAST16_g, :H5T_NATIVE_INT_LEAST16_g, :hid_t

    attach_variable :H5T_NATIVE_UINT_LEAST16_g, :H5T_NATIVE_UINT_LEAST16_g, :hid_t

    attach_variable :H5T_NATIVE_INT_FAST16_g, :H5T_NATIVE_INT_FAST16_g, :hid_t

    attach_variable :H5T_NATIVE_UINT_FAST16_g, :H5T_NATIVE_UINT_FAST16_g, :hid_t

    attach_variable :H5T_NATIVE_INT32_g, :H5T_NATIVE_INT32_g, :hid_t

    attach_variable :H5T_NATIVE_UINT32_g, :H5T_NATIVE_UINT32_g, :hid_t

    attach_variable :H5T_NATIVE_INT_LEAST32_g, :H5T_NATIVE_INT_LEAST32_g, :hid_t

    attach_variable :H5T_NATIVE_UINT_LEAST32_g, :H5T_NATIVE_UINT_LEAST32_g, :hid_t

    attach_variable :H5T_NATIVE_INT_FAST32_g, :H5T_NATIVE_INT_FAST32_g, :hid_t

    attach_variable :H5T_NATIVE_UINT_FAST32_g, :H5T_NATIVE_UINT_FAST32_g, :hid_t

    attach_variable :H5T_NATIVE_INT64_g, :H5T_NATIVE_INT64_g, :hid_t

    attach_variable :H5T_NATIVE_UINT64_g, :H5T_NATIVE_UINT64_g, :hid_t

    attach_variable :H5T_NATIVE_INT_LEAST64_g, :H5T_NATIVE_INT_LEAST64_g, :hid_t

    attach_variable :H5T_NATIVE_UINT_LEAST64_g, :H5T_NATIVE_UINT_LEAST64_g, :hid_t

    attach_variable :H5T_NATIVE_INT_FAST64_g, :H5T_NATIVE_INT_FAST64_g, :hid_t

    attach_variable :H5T_NATIVE_UINT_FAST64_g, :H5T_NATIVE_UINT_FAST64_g, :hid_t

    attach_function 'H5Tcreate', %i[
      H5T_class_t
      size_t
    ], :hid_t

    attach_function 'H5Tcopy', [
      :hid_t
    ], :hid_t

    attach_function 'H5Tclose', [
      :hid_t
    ], :herr_t

    attach_function 'H5Tclose_async', %i[
      string
      string
      uint
      hid_t
      hid_t
    ], :herr_t

    attach_function 'H5Tequal', %i[
      hid_t
      hid_t
    ], :htri_t

    attach_function 'H5Tlock', [
      :hid_t
    ], :herr_t

    attach_function 'H5Tcommit2', %i[
      hid_t
      string
      hid_t
      hid_t
      hid_t
      hid_t
    ], :herr_t

    attach_function 'H5Tcommit_async', %i[
      string
      string
      uint
      hid_t
      string
      hid_t
      hid_t
      hid_t
      hid_t
      hid_t
    ], :herr_t

    attach_function 'H5Topen2', %i[
      hid_t
      string
      hid_t
    ], :hid_t

    attach_function 'H5Topen_async', %i[
      string
      string
      uint
      hid_t
      string
      hid_t
      hid_t
    ], :hid_t

    attach_function 'H5Tcommit_anon', %i[
      hid_t
      hid_t
      hid_t
      hid_t
    ], :herr_t

    attach_function 'H5Tget_create_plist', [
      :hid_t
    ], :hid_t

    attach_function 'H5Tcommitted', [
      :hid_t
    ], :htri_t

    attach_function 'H5Tencode', %i[
      hid_t
      pointer
      pointer
    ], :herr_t

    attach_function 'H5Tdecode', [
      :pointer
    ], :hid_t

    attach_function 'H5Tflush', [
      :hid_t
    ], :herr_t

    attach_function 'H5Trefresh', [
      :hid_t
    ], :herr_t

    attach_function 'H5Tinsert', %i[
      hid_t
      string
      size_t
      hid_t
    ], :herr_t

    attach_function 'H5Tpack', [
      :hid_t
    ], :herr_t

    attach_function 'H5Tenum_create', [
      :hid_t
    ], :hid_t

    attach_function 'H5Tenum_insert', %i[
      hid_t
      string
      pointer
    ], :herr_t

    attach_function 'H5Tenum_nameof', %i[
      hid_t
      pointer
      string
      size_t
    ], :herr_t

    attach_function 'H5Tenum_valueof', %i[
      hid_t
      string
      pointer
    ], :herr_t

    attach_function 'H5Tvlen_create', [
      :hid_t
    ], :hid_t

    attach_function 'H5Tarray_create2', %i[
      hid_t
      uint
      pointer
    ], :hid_t

    attach_function 'H5Tget_array_ndims', [
      :hid_t
    ], :int

    attach_function 'H5Tget_array_dims2', %i[
      hid_t
      pointer
    ], :int

    attach_function 'H5Tset_tag', %i[
      hid_t
      string
    ], :herr_t

    attach_function 'H5Tget_tag', [
      :hid_t
    ], :string

    attach_function 'H5Tget_super', [
      :hid_t
    ], :hid_t

    attach_function 'H5Tget_class', [
      :hid_t
    ], :H5T_class_t

    attach_function 'H5Tdetect_class', %i[
      hid_t
      H5T_class_t
    ], :htri_t

    attach_function 'H5Tget_size', [
      :hid_t
    ], :size_t

    attach_function 'H5Tget_order', [
      :hid_t
    ], :H5T_order_t

    attach_function 'H5Tget_precision', [
      :hid_t
    ], :size_t

    attach_function 'H5Tget_offset', [
      :hid_t
    ], :int

    attach_function 'H5Tget_pad', %i[
      hid_t
      pointer
      pointer
    ], :herr_t

    attach_function 'H5Tget_sign', [
      :hid_t
    ], :H5T_sign_t

    attach_function 'H5Tget_fields', %i[
      hid_t
      pointer
      pointer
      pointer
      pointer
      pointer
    ], :herr_t

    attach_function 'H5Tget_ebias', [
      :hid_t
    ], :size_t

    attach_function 'H5Tget_norm', [
      :hid_t
    ], :H5T_norm_t

    attach_function 'H5Tget_inpad', [
      :hid_t
    ], :H5T_pad_t

    attach_function 'H5Tget_strpad', [
      :hid_t
    ], :H5T_str_t

    attach_function 'H5Tget_nmembers', [
      :hid_t
    ], :int

    attach_function 'H5Tget_member_name', %i[
      hid_t
      uint
    ], :string

    attach_function 'H5Tget_member_index', %i[
      hid_t
      string
    ], :int

    attach_function 'H5Tget_member_offset', %i[
      hid_t
      uint
    ], :size_t

    attach_function 'H5Tget_member_class', %i[
      hid_t
      uint
    ], :H5T_class_t

    attach_function 'H5Tget_member_type', %i[
      hid_t
      uint
    ], :hid_t

    attach_function 'H5Tget_member_value', %i[
      hid_t
      uint
      pointer
    ], :herr_t

    attach_function 'H5Tget_cset', [
      :hid_t
    ], :H5T_cset_t

    attach_function 'H5Tis_variable_str', [
      :hid_t
    ], :htri_t

    attach_function 'H5Tget_native_type', %i[
      hid_t
      H5T_direction_t
    ], :hid_t

    attach_function 'H5Tset_size', %i[
      hid_t
      size_t
    ], :herr_t

    attach_function 'H5Tset_order', %i[
      hid_t
      H5T_order_t
    ], :herr_t

    attach_function 'H5Tset_precision', %i[
      hid_t
      size_t
    ], :herr_t

    attach_function 'H5Tset_offset', %i[
      hid_t
      size_t
    ], :herr_t

    attach_function 'H5Tset_pad', %i[
      hid_t
      H5T_pad_t
      H5T_pad_t
    ], :herr_t

    attach_function 'H5Tset_sign', %i[
      hid_t
      H5T_sign_t
    ], :herr_t

    attach_function 'H5Tset_fields', %i[
      hid_t
      size_t
      size_t
      size_t
      size_t
      size_t
    ], :herr_t

    attach_function 'H5Tset_ebias', %i[
      hid_t
      size_t
    ], :herr_t

    attach_function 'H5Tset_norm', %i[
      hid_t
      H5T_norm_t
    ], :herr_t

    attach_function 'H5Tset_inpad', %i[
      hid_t
      H5T_pad_t
    ], :herr_t

    attach_function 'H5Tset_cset', %i[
      hid_t
      H5T_cset_t
    ], :herr_t

    attach_function 'H5Tset_strpad', %i[
      hid_t
      H5T_str_t
    ], :herr_t

    attach_function 'H5Tconvert', %i[
      hid_t
      hid_t
      size_t
      pointer
      pointer
      hid_t
    ], :herr_t

    attach_function 'H5Treclaim', %i[
      hid_t
      hid_t
      hid_t
      pointer
    ], :herr_t

    attach_function 'H5Tcommit1', %i[
      hid_t
      string
      hid_t
    ], :herr_t

    attach_function 'H5Topen1', %i[
      hid_t
      string
    ], :hid_t

    attach_function 'H5Tarray_create1', %i[
      hid_t
      int
      pointer
      pointer
    ], :hid_t

    attach_function 'H5Tget_array_dims1', %i[
      hid_t
      pointer
      pointer
    ], :int

    class Anon_Type_22 < ::FFI::Struct
      layout \
        :corder_valid, :hbool_t,
        :corder, :H5O_msg_crt_idx_t,
        :cset, :H5T_cset_t,
        :data_size, :hsize_t
    end

    H5AInfoT = Anon_Type_22

    typedef :pointer, :H5A_operator2_t

    attach_function 'H5Aclose', [
      :hid_t
    ], :herr_t

    attach_function 'H5Aclose_async', %i[
      string
      string
      uint
      hid_t
      hid_t
    ], :herr_t

    attach_function 'H5Acreate2', %i[
      hid_t
      string
      hid_t
      hid_t
      hid_t
      hid_t
    ], :hid_t

    attach_function 'H5Acreate_async', %i[
      string
      string
      uint
      hid_t
      string
      hid_t
      hid_t
      hid_t
      hid_t
      hid_t
    ], :hid_t

    attach_function 'H5Acreate_by_name', %i[
      hid_t
      string
      string
      hid_t
      hid_t
      hid_t
      hid_t
      hid_t
    ], :hid_t

    attach_function 'H5Acreate_by_name_async', %i[
      string
      string
      uint
      hid_t
      string
      string
      hid_t
      hid_t
      hid_t
      hid_t
      hid_t
      hid_t
    ], :hid_t

    attach_function 'H5Adelete', %i[
      hid_t
      string
    ], :herr_t

    attach_function 'H5Adelete_by_idx', %i[
      hid_t
      string
      H5_index_t
      H5_iter_order_t
      hsize_t
      hid_t
    ], :herr_t

    attach_function 'H5Adelete_by_name', %i[
      hid_t
      string
      string
      hid_t
    ], :herr_t

    attach_function 'H5Aexists', %i[
      hid_t
      string
    ], :htri_t

    attach_function 'H5Aexists_async', %i[
      string
      string
      uint
      hid_t
      string
      pointer
      hid_t
    ], :herr_t

    attach_function 'H5Aexists_by_name', %i[
      hid_t
      string
      string
      hid_t
    ], :htri_t

    attach_function 'H5Aexists_by_name_async', %i[
      string
      string
      uint
      hid_t
      string
      string
      pointer
      hid_t
      hid_t
    ], :herr_t

    attach_function 'H5Aget_create_plist', [
      :hid_t
    ], :hid_t

    attach_function 'H5Aget_info', [
      :hid_t,
      H5AInfoT.ptr
    ], :herr_t

    attach_function 'H5Aget_info_by_idx', [
      :hid_t,
      :string,
      :H5_index_t,
      :H5_iter_order_t,
      :hsize_t,
      H5AInfoT.ptr,
      :hid_t
    ], :herr_t

    attach_function 'H5Aget_info_by_name', [
      :hid_t,
      :string,
      :string,
      H5AInfoT.ptr,
      :hid_t
    ], :herr_t

    attach_function 'H5Aget_name', %i[
      hid_t
      size_t
      string
    ], :ssize_t

    attach_function 'H5Aget_name_by_idx', %i[
      hid_t
      string
      H5_index_t
      H5_iter_order_t
      hsize_t
      string
      size_t
      hid_t
    ], :ssize_t

    attach_function 'H5Aget_space', [
      :hid_t
    ], :hid_t

    attach_function 'H5Aget_storage_size', [
      :hid_t
    ], :hsize_t

    attach_function 'H5Aget_type', [
      :hid_t
    ], :hid_t

    attach_function 'H5Aiterate2', %i[
      hid_t
      H5_index_t
      H5_iter_order_t
      pointer
      H5A_operator2_t
      pointer
    ], :herr_t

    attach_function 'H5Aiterate_by_name', %i[
      hid_t
      string
      H5_index_t
      H5_iter_order_t
      pointer
      H5A_operator2_t
      pointer
      hid_t
    ], :herr_t

    attach_function 'H5Aopen', %i[
      hid_t
      string
      hid_t
    ], :hid_t

    attach_function 'H5Aopen_async', %i[
      string
      string
      uint
      hid_t
      string
      hid_t
      hid_t
    ], :hid_t

    attach_function 'H5Aopen_by_idx', %i[
      hid_t
      string
      H5_index_t
      H5_iter_order_t
      hsize_t
      hid_t
      hid_t
    ], :hid_t

    attach_function 'H5Aopen_by_idx_async', %i[
      string
      string
      uint
      hid_t
      string
      H5_index_t
      H5_iter_order_t
      hsize_t
      hid_t
      hid_t
      hid_t
    ], :hid_t

    attach_function 'H5Aopen_by_name', %i[
      hid_t
      string
      string
      hid_t
      hid_t
    ], :hid_t

    attach_function 'H5Aopen_by_name_async', %i[
      string
      string
      uint
      hid_t
      string
      string
      hid_t
      hid_t
      hid_t
    ], :hid_t

    attach_function 'H5Aread', %i[
      hid_t
      hid_t
      pointer
    ], :herr_t

    attach_function 'H5Aread_async', %i[
      string
      string
      uint
      hid_t
      hid_t
      pointer
      hid_t
    ], :herr_t

    attach_function 'H5Arename', %i[
      hid_t
      string
      string
    ], :herr_t

    attach_function 'H5Arename_async', %i[
      string
      string
      uint
      hid_t
      string
      string
      hid_t
    ], :herr_t

    attach_function 'H5Arename_by_name_async', %i[
      string
      string
      uint
      hid_t
      string
      string
      string
      hid_t
      hid_t
    ], :herr_t

    attach_function 'H5Awrite', %i[
      hid_t
      hid_t
      pointer
    ], :herr_t

    attach_function 'H5Awrite_async', %i[
      string
      string
      uint
      hid_t
      hid_t
      pointer
      hid_t
    ], :herr_t

    attach_function 'H5Arename_by_name', %i[
      hid_t
      string
      string
      string
      hid_t
    ], :herr_t

    typedef :pointer, :H5A_operator1_t

    attach_function 'H5Acreate1', %i[
      hid_t
      string
      hid_t
      hid_t
      hid_t
    ], :hid_t

    attach_function 'H5Aget_num_attrs', [
      :hid_t
    ], :int

    attach_function 'H5Aiterate1', %i[
      hid_t
      pointer
      H5A_operator1_t
      pointer
    ], :herr_t

    attach_function 'H5Aopen_idx', %i[
      hid_t
      uint
    ], :hid_t

    attach_function 'H5Aopen_name', %i[
      hid_t
      string
    ], :hid_t

    enum :H5C_cache_incr_mode, [
      :H5C_incr__off, 0,
      :H5C_incr__threshold, 1
    ]

    enum :H5C_cache_flash_incr_mode, [
      :H5C_flash_incr__off, 0,
      :H5C_flash_incr__add_space, 1
    ]

    enum :H5C_cache_decr_mode, [
      :H5C_decr__off, 0,
      :H5C_decr__threshold, 1,
      :H5C_decr__age_out, 2,
      :H5C_decr__age_out_with_threshold, 3
    ]

    class H5ACCacheConfigT < ::FFI::Struct
      layout \
        :version, :int,
        :rpt_fcn_enabled, :hbool_t,
        :open_trace_file, :hbool_t,
        :close_trace_file, :hbool_t,
        :trace_file_name, [:char, 1025],
        :evictions_enabled, :hbool_t,
        :set_initial_size, :hbool_t,
        :initial_size, :size_t,
        :min_clean_fraction, :double,
        :max_size, :size_t,
        :min_size, :size_t,
        :epoch_length, :long,
        :incr_mode, :H5C_cache_incr_mode,
        :lower_hr_threshold, :double,
        :increment, :double,
        :apply_max_increment, :hbool_t,
        :max_increment, :size_t,
        :flash_incr_mode, :H5C_cache_flash_incr_mode,
        :flash_multiple, :double,
        :flash_threshold, :double,
        :decr_mode, :H5C_cache_decr_mode,
        :upper_hr_threshold, :double,
        :decrement, :double,
        :apply_max_decrement, :hbool_t,
        :max_decrement, :size_t,
        :epochs_before_eviction, :int,
        :apply_empty_reserve, :hbool_t,
        :empty_reserve, :double,
        :dirty_bytes_threshold, :size_t,
        :metadata_write_strategy, :int
    end

    # H5ACCacheConfigT = H5ACCacheConfigT

    class H5ACCacheImageConfigT < ::FFI::Struct
      layout \
        :version, :int,
        :generate_image, :hbool_t,
        :save_resize_status, :hbool_t,
        :entry_ageout, :int
    end

    # H5ACCacheImageConfigT = H5ACCacheImageConfigT

    enum :H5D_layout_t, [
      :H5D_LAYOUT_ERROR, 4_294_967_295,
      :H5D_COMPACT, 0,
      :H5D_CONTIGUOUS, 1,
      :H5D_CHUNKED, 2,
      :H5D_VIRTUAL, 3,
      :H5D_NLAYOUTS, 4
    ]

    typedef :H5D_layout_t, :H5D_layout_t

    enum :H5D_chunk_index_t, [
      :H5D_CHUNK_IDX_BTREE, 0,
      :H5D_CHUNK_IDX_SINGLE, 1,
      :H5D_CHUNK_IDX_NONE, 2,
      :H5D_CHUNK_IDX_FARRAY, 3,
      :H5D_CHUNK_IDX_EARRAY, 4,
      :H5D_CHUNK_IDX_BT2, 5,
      :H5D_CHUNK_IDX_NTYPES, 6
    ]

    typedef :H5D_chunk_index_t, :H5D_chunk_index_t

    enum :H5D_alloc_time_t, [
      :H5D_ALLOC_TIME_ERROR, 4_294_967_295,
      :H5D_ALLOC_TIME_DEFAULT, 0,
      :H5D_ALLOC_TIME_EARLY, 1,
      :H5D_ALLOC_TIME_LATE, 2,
      :H5D_ALLOC_TIME_INCR, 3
    ]

    typedef :H5D_alloc_time_t, :H5D_alloc_time_t

    enum :H5D_space_status_t, [
      :H5D_SPACE_STATUS_ERROR, 4_294_967_295,
      :H5D_SPACE_STATUS_NOT_ALLOCATED, 0,
      :H5D_SPACE_STATUS_PART_ALLOCATED, 1,
      :H5D_SPACE_STATUS_ALLOCATED, 2
    ]

    typedef :H5D_space_status_t, :H5D_space_status_t

    enum :H5D_fill_time_t, [
      :H5D_FILL_TIME_ERROR, 4_294_967_295,
      :H5D_FILL_TIME_ALLOC, 0,
      :H5D_FILL_TIME_NEVER, 1,
      :H5D_FILL_TIME_IFSET, 2
    ]

    typedef :H5D_fill_time_t, :H5D_fill_time_t

    enum :H5D_fill_value_t, [
      :H5D_FILL_VALUE_ERROR, 4_294_967_295,
      :H5D_FILL_VALUE_UNDEFINED, 0,
      :H5D_FILL_VALUE_DEFAULT, 1,
      :H5D_FILL_VALUE_USER_DEFINED, 2
    ]

    typedef :H5D_fill_value_t, :H5D_fill_value_t

    enum :H5D_vds_view_t, [
      :H5D_VDS_ERROR, 4_294_967_295,
      :H5D_VDS_FIRST_MISSING, 0,
      :H5D_VDS_LAST_AVAILABLE, 1
    ]

    typedef :H5D_vds_view_t, :H5D_vds_view_t

    typedef :pointer, :H5D_append_cb_t

    typedef :pointer, :H5D_operator_t

    typedef :pointer, :H5D_scatter_func_t

    typedef :pointer, :H5D_gather_func_t

    typedef :pointer, :H5D_chunk_iter_op_t

    attach_function 'H5Dcreate2', %i[
      hid_t
      string
      hid_t
      hid_t
      hid_t
      hid_t
      hid_t
    ], :hid_t

    attach_function 'H5Dcreate_async', %i[
      string
      string
      uint
      hid_t
      string
      hid_t
      hid_t
      hid_t
      hid_t
      hid_t
      hid_t
    ], :hid_t

    attach_function 'H5Dcreate_anon', %i[
      hid_t
      hid_t
      hid_t
      hid_t
      hid_t
    ], :hid_t

    attach_function 'H5Dopen2', %i[
      hid_t
      string
      hid_t
    ], :hid_t

    attach_function 'H5Dopen_async', %i[
      string
      string
      uint
      hid_t
      string
      hid_t
      hid_t
    ], :hid_t

    attach_function 'H5Dget_space', [
      :hid_t
    ], :hid_t

    attach_function 'H5Dget_space_async', %i[
      string
      string
      uint
      hid_t
      hid_t
    ], :hid_t

    attach_function 'H5Dget_space_status', %i[
      hid_t
      pointer
    ], :herr_t

    attach_function 'H5Dget_type', [
      :hid_t
    ], :hid_t

    attach_function 'H5Dget_create_plist', [
      :hid_t
    ], :hid_t

    attach_function 'H5Dget_access_plist', [
      :hid_t
    ], :hid_t

    attach_function 'H5Dget_storage_size', [
      :hid_t
    ], :hsize_t

    attach_function 'H5Dget_chunk_storage_size', %i[
      hid_t
      pointer
      pointer
    ], :herr_t

    attach_function 'H5Dget_num_chunks', %i[
      hid_t
      hid_t
      pointer
    ], :herr_t

    attach_function 'H5Dget_chunk_info_by_coord', %i[
      hid_t
      pointer
      pointer
      pointer
      pointer
    ], :herr_t

    attach_function 'H5Dchunk_iter', %i[
      hid_t
      hid_t
      H5D_chunk_iter_op_t
      pointer
    ], :herr_t

    attach_function 'H5Dget_chunk_info', %i[
      hid_t
      hid_t
      hsize_t
      pointer
      pointer
      pointer
      pointer
    ], :herr_t

    attach_function 'H5Dget_offset', [
      :hid_t
    ], :haddr_t

    attach_function 'H5Dread', %i[
      hid_t
      hid_t
      hid_t
      hid_t
      hid_t
      pointer
    ], :herr_t

    attach_function 'H5Dread_multi', %i[
      size_t
      pointer
      pointer
      pointer
      pointer
      hid_t
      pointer
    ], :herr_t

    attach_function 'H5Dread_async', %i[
      string
      string
      uint
      hid_t
      hid_t
      hid_t
      hid_t
      hid_t
      pointer
      hid_t
    ], :herr_t

    attach_function 'H5Dread_multi_async', %i[
      string
      string
      uint
      size_t
      pointer
      pointer
      pointer
      pointer
      hid_t
      pointer
      hid_t
    ], :herr_t

    attach_function 'H5Dwrite', %i[
      hid_t
      hid_t
      hid_t
      hid_t
      hid_t
      pointer
    ], :herr_t

    attach_function 'H5Dwrite_multi', %i[
      size_t
      pointer
      pointer
      pointer
      pointer
      hid_t
      pointer
    ], :herr_t

    attach_function 'H5Dwrite_async', %i[
      string
      string
      uint
      hid_t
      hid_t
      hid_t
      hid_t
      hid_t
      pointer
      hid_t
    ], :herr_t

    attach_function 'H5Dwrite_multi_async', %i[
      string
      string
      uint
      size_t
      pointer
      pointer
      pointer
      pointer
      hid_t
      pointer
      hid_t
    ], :herr_t

    attach_function 'H5Dwrite_chunk', %i[
      hid_t
      hid_t
      uint32_t
      pointer
      size_t
      pointer
    ], :herr_t

    attach_function 'H5Dread_chunk', %i[
      hid_t
      hid_t
      pointer
      pointer
      pointer
    ], :herr_t

    attach_function 'H5Diterate', %i[
      pointer
      hid_t
      hid_t
      H5D_operator_t
      pointer
    ], :herr_t

    attach_function 'H5Dvlen_get_buf_size', %i[
      hid_t
      hid_t
      hid_t
      pointer
    ], :herr_t

    attach_function 'H5Dfill', %i[
      pointer
      hid_t
      pointer
      hid_t
      hid_t
    ], :herr_t

    attach_function 'H5Dset_extent', %i[
      hid_t
      pointer
    ], :herr_t

    attach_function 'H5Dset_extent_async', %i[
      string
      string
      uint
      hid_t
      pointer
      hid_t
    ], :herr_t

    attach_function 'H5Dflush', [
      :hid_t
    ], :herr_t

    attach_function 'H5Drefresh', [
      :hid_t
    ], :herr_t

    attach_function 'H5Dscatter', %i[
      H5D_scatter_func_t
      pointer
      hid_t
      hid_t
      pointer
    ], :herr_t

    attach_function 'H5Dgather', %i[
      hid_t
      pointer
      hid_t
      size_t
      pointer
      H5D_gather_func_t
      pointer
    ], :herr_t

    attach_function 'H5Dclose', [
      :hid_t
    ], :herr_t

    attach_function 'H5Dclose_async', %i[
      string
      string
      uint
      hid_t
      hid_t
    ], :herr_t

    attach_function 'H5Ddebug', [
      :hid_t
    ], :herr_t

    attach_function 'H5Dformat_convert', [
      :hid_t
    ], :herr_t

    attach_function 'H5Dget_chunk_index_type', %i[
      hid_t
      pointer
    ], :herr_t

    attach_function 'H5Dcreate1', %i[
      hid_t
      string
      hid_t
      hid_t
      hid_t
    ], :hid_t

    attach_function 'H5Dopen1', %i[
      hid_t
      string
    ], :hid_t

    attach_function 'H5Dextend', %i[
      hid_t
      pointer
    ], :herr_t

    attach_function 'H5Dvlen_reclaim', %i[
      hid_t
      hid_t
      hid_t
      pointer
    ], :herr_t

    class Anon_Type_24 < ::FFI::Union
      layout \
        :__wch, :uint,
        :__wchb, [:char, 4]
    end

    class Anon_Type_23 < ::FFI::Struct
      layout \
        :__count, :int,
        :__value, Anon_Type_24
    end

    C_MbstateT = Anon_Type_23

    class C_GFposT < ::FFI::Struct
      layout \
        :__pos, :__off_t,
        :__state, C_MbstateT
    end

    C_FposT = C_GFposT

    class C_GFpos64T < ::FFI::Struct
      layout \
        :__pos, :__off64_t,
        :__state, C_MbstateT
    end

    C_Fpos64T = C_GFpos64T

    class C_IO_FILE < ::FFI::Struct
    end

    # Already defined? C_IO_FILE

    C__FILE = C_IO_FILE

    # Already defined? C_IO_FILE

    # Already defined? C_IO_FILE

    FILE = C_IO_FILE

    # Already defined? C_IO_FILE

    class C_IOMarker < ::FFI::Struct
    end

    class C_IOCodecvt < ::FFI::Struct
    end

    class C_IOWideData < ::FFI::Struct
    end

    typedef :void, :_IO_lock_t

    # Already defined? C_IO_FILE

    # typedef :function, :cookie_read_function_t

    # typedef :function, :cookie_write_function_t

    # typedef :function, :cookie_seek_function_t

    # typedef :function, :cookie_close_function_t

    class C_IOCookieIoFunctionsT < ::FFI::Struct
      layout \
        :read, :pointer,
        :write, :pointer,
        :seek, :pointer,
        :close, :pointer
    end

    CookieIoFunctionsT = C_IOCookieIoFunctionsT

    FposT = C_FposT

    attach_variable :stdin, :stdin, FILE.ptr

    attach_variable :stdout, :stdout, FILE.ptr

    attach_variable :stderr, :stderr, FILE.ptr

    attach_function 'remove', [
      :string
    ], :int

    attach_function 'rename', %i[
      string
      string
    ], :int

    attach_function 'renameat', %i[
      int
      string
      int
      string
    ], :int

    attach_function 'fclose', [
      FILE.ptr
    ], :int

    attach_function 'tmpfile', [], FILE.ptr

    attach_function 'tmpnam', [
      :pointer # [:char, 20]
    ], :string

    attach_function 'tmpnam_r', [
      :pointer # [:char, 20]
    ], :string

    attach_function 'tempnam', %i[
      string
      string
    ], :string

    attach_function 'fflush', [
      FILE.ptr
    ], :int

    attach_function 'fflush_unlocked', [
      FILE.ptr
    ], :int

    attach_function 'fopen', %i[
      string
      string
    ], FILE.ptr

    attach_function 'freopen', [
      :string,
      :string,
      FILE.ptr
    ], FILE.ptr

    attach_function 'fdopen', %i[
      int
      string
    ], FILE.ptr

    attach_function 'fopencookie', [
      :pointer,
      :string,
      CookieIoFunctionsT
    ], FILE.ptr

    attach_function 'fmemopen', %i[
      pointer
      size_t
      string
    ], FILE.ptr

    attach_function 'open_memstream', %i[
      pointer
      pointer
    ], FILE.ptr

    attach_function 'setbuf', [
      FILE.ptr,
      :string
    ], :void

    attach_function 'setvbuf', [
      FILE.ptr,
      :string,
      :int,
      :size_t
    ], :int

    attach_function 'setbuffer', [
      FILE.ptr,
      :string,
      :size_t
    ], :void

    attach_function 'setlinebuf', [
      FILE.ptr
    ], :void

    attach_function 'fprintf', [
      FILE.ptr,
      :string
    ], :int

    attach_function 'printf', [
      :string
    ], :int

    attach_function 'sprintf', %i[
      string
      string
    ], :int

    attach_function 'vfprintf', [
      FILE.ptr,
      :string,
      :__gnuc_va_list
    ], :int

    attach_function 'vprintf', %i[
      string
      __gnuc_va_list
    ], :int

    attach_function 'vsprintf', %i[
      string
      string
      __gnuc_va_list
    ], :int

    attach_function 'snprintf', %i[
      string
      size_t
      string
    ], :int

    attach_function 'vsnprintf', %i[
      string
      size_t
      string
      __gnuc_va_list
    ], :int

    attach_function 'vasprintf', %i[
      pointer
      string
      __gnuc_va_list
    ], :int

    attach_function '__asprintf', %i[
      pointer
      string
    ], :int

    attach_function 'asprintf', %i[
      pointer
      string
    ], :int

    attach_function 'vdprintf', %i[
      int
      string
      __gnuc_va_list
    ], :int

    attach_function 'dprintf', %i[
      int
      string
    ], :int

    attach_function 'fscanf', [
      FILE.ptr,
      :string
    ], :int

    attach_function 'scanf', [
      :string
    ], :int

    attach_function 'sscanf', %i[
      string
      string
    ], :int

    typedef :float, :_Float32

    typedef :double, :_Float64

    typedef :double, :_Float32x

    typedef :long_double, :_Float64x

    # attach_function 'fscanf', [
    #   FILE.ptr,
    #   :string
    # ], :int

    # attach_function 'scanf', [
    #   :string
    # ], :int

    # attach_function 'sscanf', %i[
    #   string
    #   string
    # ], :int

    # attach_function 'vfscanf', [
    #   FILE.ptr,
    #   :string,
    #   :__gnuc_va_list
    # ], :int

    # attach_function 'vscanf', %i[
    #   string
    #   __gnuc_va_list
    # ], :int

    # attach_function 'vsscanf', %i[
    #   string
    #   string
    #   __gnuc_va_list
    # ], :int

    # attach_function 'vfscanf', [
    #   FILE.ptr,
    #   :string,
    #   :__gnuc_va_list
    # ], :int

    attach_function 'vscanf', %i[
      string
      __gnuc_va_list
    ], :int

    attach_function 'vsscanf', %i[
      string
      string
      __gnuc_va_list
    ], :int

    attach_function 'fgetc', [
      FILE.ptr
    ], :int

    attach_function 'getc', [
      FILE.ptr
    ], :int

    attach_function 'getchar', [], :int

    attach_function 'getc_unlocked', [
      FILE.ptr
    ], :int

    attach_function 'getchar_unlocked', [], :int

    attach_function 'fgetc_unlocked', [
      FILE.ptr
    ], :int

    attach_function 'fputc', [
      :int,
      FILE.ptr
    ], :int

    attach_function 'putc', [
      :int,
      FILE.ptr
    ], :int

    attach_function 'putchar', [
      :int
    ], :int

    attach_function 'fputc_unlocked', [
      :int,
      FILE.ptr
    ], :int

    attach_function 'putc_unlocked', [
      :int,
      FILE.ptr
    ], :int

    attach_function 'putchar_unlocked', [
      :int
    ], :int

    attach_function 'getw', [
      FILE.ptr
    ], :int

    attach_function 'putw', [
      :int,
      FILE.ptr
    ], :int

    attach_function 'fgets', [
      :string,
      :int,
      FILE.ptr
    ], :string

    attach_function '__getdelim', [
      :pointer,
      :pointer,
      :int,
      FILE.ptr
    ], :__ssize_t

    attach_function 'getdelim', [
      :pointer,
      :pointer,
      :int,
      FILE.ptr
    ], :__ssize_t

    attach_function 'getline', [
      :pointer,
      :pointer,
      FILE.ptr
    ], :__ssize_t

    attach_function 'fputs', [
      :string,
      FILE.ptr
    ], :int

    attach_function 'puts', [
      :string
    ], :int

    attach_function 'ungetc', [
      :int,
      FILE.ptr
    ], :int

    attach_function 'fread', [
      :pointer,
      :size_t,
      :size_t,
      FILE.ptr
    ], :ulong

    attach_function 'fwrite', [
      :pointer,
      :size_t,
      :size_t,
      FILE.ptr
    ], :ulong

    attach_function 'fread_unlocked', [
      :pointer,
      :size_t,
      :size_t,
      FILE.ptr
    ], :size_t

    attach_function 'fwrite_unlocked', [
      :pointer,
      :size_t,
      :size_t,
      FILE.ptr
    ], :size_t

    attach_function 'fseek', [
      FILE.ptr,
      :long,
      :int
    ], :int

    attach_function 'ftell', [
      FILE.ptr
    ], :long

    attach_function 'rewind', [
      FILE.ptr
    ], :void

    attach_function 'fseeko', [
      FILE.ptr,
      :__off_t,
      :int
    ], :int

    attach_function 'ftello', [
      FILE.ptr
    ], :__off_t

    attach_function 'fgetpos', [
      FILE.ptr,
      FposT.ptr
    ], :int

    attach_function 'fsetpos', [
      FILE.ptr,
      FposT.ptr
    ], :int

    attach_function 'clearerr', [
      FILE.ptr
    ], :void

    attach_function 'feof', [
      FILE.ptr
    ], :int

    attach_function 'ferror', [
      FILE.ptr
    ], :int

    attach_function 'clearerr_unlocked', [
      FILE.ptr
    ], :void

    attach_function 'feof_unlocked', [
      FILE.ptr
    ], :int

    attach_function 'ferror_unlocked', [
      FILE.ptr
    ], :int

    attach_function 'perror', [
      :string
    ], :void

    attach_function 'fileno', [
      FILE.ptr
    ], :int

    attach_function 'fileno_unlocked', [
      FILE.ptr
    ], :int

    attach_function 'pclose', [
      FILE.ptr
    ], :int

    attach_function 'popen', %i[
      string
      string
    ], FILE.ptr

    attach_function 'ctermid', [
      :string
    ], :string

    attach_function 'flockfile', [
      FILE.ptr
    ], :void

    attach_function 'ftrylockfile', [
      FILE.ptr
    ], :int

    attach_function 'funlockfile', [
      FILE.ptr
    ], :void

    attach_function '__uflow', [
      FILE.ptr
    ], :int

    attach_function '__overflow', [
      FILE.ptr,
      :int
    ], :int

    enum :H5E_type_t, [
      :H5E_MAJOR, 0,
      :H5E_MINOR, 1
    ]

    typedef :H5E_type_t, :H5E_type_t

    class H5EError2T < ::FFI::Struct
      layout \
        :cls_id, :hid_t,
        :maj_num, :hid_t,
        :min_num, :hid_t,
        :line, :uint,
        :func_name, :string,
        :file_name, :string,
        :desc, :string
    end

    # H5EError2T = H5EError2T

    attach_variable :H5E_ERR_CLS_g, :H5E_ERR_CLS_g, :hid_t

    attach_variable :H5E_FUNC_g, :H5E_FUNC_g, :hid_t

    attach_variable :H5E_FILE_g, :H5E_FILE_g, :hid_t

    attach_variable :H5E_VOL_g, :H5E_VOL_g, :hid_t

    attach_variable :H5E_SOHM_g, :H5E_SOHM_g, :hid_t

    attach_variable :H5E_SYM_g, :H5E_SYM_g, :hid_t

    attach_variable :H5E_PLUGIN_g, :H5E_PLUGIN_g, :hid_t

    attach_variable :H5E_VFL_g, :H5E_VFL_g, :hid_t

    attach_variable :H5E_INTERNAL_g, :H5E_INTERNAL_g, :hid_t

    attach_variable :H5E_BTREE_g, :H5E_BTREE_g, :hid_t

    attach_variable :H5E_REFERENCE_g, :H5E_REFERENCE_g, :hid_t

    attach_variable :H5E_DATASPACE_g, :H5E_DATASPACE_g, :hid_t

    attach_variable :H5E_RESOURCE_g, :H5E_RESOURCE_g, :hid_t

    attach_variable :H5E_EVENTSET_g, :H5E_EVENTSET_g, :hid_t

    attach_variable :H5E_ID_g, :H5E_ID_g, :hid_t

    attach_variable :H5E_RS_g, :H5E_RS_g, :hid_t

    attach_variable :H5E_FARRAY_g, :H5E_FARRAY_g, :hid_t

    attach_variable :H5E_HEAP_g, :H5E_HEAP_g, :hid_t

    attach_variable :H5E_MAP_g, :H5E_MAP_g, :hid_t

    attach_variable :H5E_ATTR_g, :H5E_ATTR_g, :hid_t

    attach_variable :H5E_IO_g, :H5E_IO_g, :hid_t

    attach_variable :H5E_EFL_g, :H5E_EFL_g, :hid_t

    attach_variable :H5E_TST_g, :H5E_TST_g, :hid_t

    attach_variable :H5E_LIB_g, :H5E_LIB_g, :hid_t

    attach_variable :H5E_PAGEBUF_g, :H5E_PAGEBUF_g, :hid_t

    attach_variable :H5E_FSPACE_g, :H5E_FSPACE_g, :hid_t

    attach_variable :H5E_DATASET_g, :H5E_DATASET_g, :hid_t

    attach_variable :H5E_STORAGE_g, :H5E_STORAGE_g, :hid_t

    attach_variable :H5E_LINK_g, :H5E_LINK_g, :hid_t

    attach_variable :H5E_PLIST_g, :H5E_PLIST_g, :hid_t

    attach_variable :H5E_DATATYPE_g, :H5E_DATATYPE_g, :hid_t

    attach_variable :H5E_OHDR_g, :H5E_OHDR_g, :hid_t

    attach_variable :H5E_NONE_MAJOR_g, :H5E_NONE_MAJOR_g, :hid_t

    attach_variable :H5E_SLIST_g, :H5E_SLIST_g, :hid_t

    attach_variable :H5E_ARGS_g, :H5E_ARGS_g, :hid_t

    attach_variable :H5E_CONTEXT_g, :H5E_CONTEXT_g, :hid_t

    attach_variable :H5E_EARRAY_g, :H5E_EARRAY_g, :hid_t

    attach_variable :H5E_PLINE_g, :H5E_PLINE_g, :hid_t

    attach_variable :H5E_ERROR_g, :H5E_ERROR_g, :hid_t

    attach_variable :H5E_CACHE_g, :H5E_CACHE_g, :hid_t

    attach_variable :H5E_BADID_g, :H5E_BADID_g, :hid_t

    attach_variable :H5E_BADGROUP_g, :H5E_BADGROUP_g, :hid_t

    attach_variable :H5E_CANTREGISTER_g, :H5E_CANTREGISTER_g, :hid_t

    attach_variable :H5E_CANTINC_g, :H5E_CANTINC_g, :hid_t

    attach_variable :H5E_CANTDEC_g, :H5E_CANTDEC_g, :hid_t

    attach_variable :H5E_NOIDS_g, :H5E_NOIDS_g, :hid_t

    attach_variable :H5E_SEEKERROR_g, :H5E_SEEKERROR_g, :hid_t

    attach_variable :H5E_READERROR_g, :H5E_READERROR_g, :hid_t

    attach_variable :H5E_WRITEERROR_g, :H5E_WRITEERROR_g, :hid_t

    attach_variable :H5E_CLOSEERROR_g, :H5E_CLOSEERROR_g, :hid_t

    attach_variable :H5E_OVERFLOW_g, :H5E_OVERFLOW_g, :hid_t

    attach_variable :H5E_FCNTL_g, :H5E_FCNTL_g, :hid_t

    attach_variable :H5E_NOSPACE_g, :H5E_NOSPACE_g, :hid_t

    attach_variable :H5E_CANTALLOC_g, :H5E_CANTALLOC_g, :hid_t

    attach_variable :H5E_CANTCOPY_g, :H5E_CANTCOPY_g, :hid_t

    attach_variable :H5E_CANTFREE_g, :H5E_CANTFREE_g, :hid_t

    attach_variable :H5E_ALREADYEXISTS_g, :H5E_ALREADYEXISTS_g, :hid_t

    attach_variable :H5E_CANTLOCK_g, :H5E_CANTLOCK_g, :hid_t

    attach_variable :H5E_CANTUNLOCK_g, :H5E_CANTUNLOCK_g, :hid_t

    attach_variable :H5E_CANTGC_g, :H5E_CANTGC_g, :hid_t

    attach_variable :H5E_CANTGETSIZE_g, :H5E_CANTGETSIZE_g, :hid_t

    attach_variable :H5E_OBJOPEN_g, :H5E_OBJOPEN_g, :hid_t

    attach_variable :H5E_CANTRESTORE_g, :H5E_CANTRESTORE_g, :hid_t

    attach_variable :H5E_CANTCOMPUTE_g, :H5E_CANTCOMPUTE_g, :hid_t

    attach_variable :H5E_CANTEXTEND_g, :H5E_CANTEXTEND_g, :hid_t

    attach_variable :H5E_CANTATTACH_g, :H5E_CANTATTACH_g, :hid_t

    attach_variable :H5E_CANTUPDATE_g, :H5E_CANTUPDATE_g, :hid_t

    attach_variable :H5E_CANTOPERATE_g, :H5E_CANTOPERATE_g, :hid_t

    attach_variable :H5E_CANTPUT_g, :H5E_CANTPUT_g, :hid_t

    attach_variable :H5E_CANTINIT_g, :H5E_CANTINIT_g, :hid_t

    attach_variable :H5E_ALREADYINIT_g, :H5E_ALREADYINIT_g, :hid_t

    attach_variable :H5E_CANTRELEASE_g, :H5E_CANTRELEASE_g, :hid_t

    attach_variable :H5E_CANTGET_g, :H5E_CANTGET_g, :hid_t

    attach_variable :H5E_CANTSET_g, :H5E_CANTSET_g, :hid_t

    attach_variable :H5E_DUPCLASS_g, :H5E_DUPCLASS_g, :hid_t

    attach_variable :H5E_SETDISALLOWED_g, :H5E_SETDISALLOWED_g, :hid_t

    attach_variable :H5E_CANTWAIT_g, :H5E_CANTWAIT_g, :hid_t

    attach_variable :H5E_CANTCANCEL_g, :H5E_CANTCANCEL_g, :hid_t

    attach_variable :H5E_CANTMERGE_g, :H5E_CANTMERGE_g, :hid_t

    attach_variable :H5E_CANTREVIVE_g, :H5E_CANTREVIVE_g, :hid_t

    attach_variable :H5E_CANTSHRINK_g, :H5E_CANTSHRINK_g, :hid_t

    attach_variable :H5E_LINKCOUNT_g, :H5E_LINKCOUNT_g, :hid_t

    attach_variable :H5E_VERSION_g, :H5E_VERSION_g, :hid_t

    attach_variable :H5E_ALIGNMENT_g, :H5E_ALIGNMENT_g, :hid_t

    attach_variable :H5E_BADMESG_g, :H5E_BADMESG_g, :hid_t

    attach_variable :H5E_CANTDELETE_g, :H5E_CANTDELETE_g, :hid_t

    attach_variable :H5E_BADITER_g, :H5E_BADITER_g, :hid_t

    attach_variable :H5E_CANTPACK_g, :H5E_CANTPACK_g, :hid_t

    attach_variable :H5E_CANTRESET_g, :H5E_CANTRESET_g, :hid_t

    attach_variable :H5E_CANTRENAME_g, :H5E_CANTRENAME_g, :hid_t

    attach_variable :H5E_SYSERRSTR_g, :H5E_SYSERRSTR_g, :hid_t

    attach_variable :H5E_NOFILTER_g, :H5E_NOFILTER_g, :hid_t

    attach_variable :H5E_CALLBACK_g, :H5E_CALLBACK_g, :hid_t

    attach_variable :H5E_CANAPPLY_g, :H5E_CANAPPLY_g, :hid_t

    attach_variable :H5E_SETLOCAL_g, :H5E_SETLOCAL_g, :hid_t

    attach_variable :H5E_NOENCODER_g, :H5E_NOENCODER_g, :hid_t

    attach_variable :H5E_CANTFILTER_g, :H5E_CANTFILTER_g, :hid_t

    attach_variable :H5E_CANTOPENOBJ_g, :H5E_CANTOPENOBJ_g, :hid_t

    attach_variable :H5E_CANTCLOSEOBJ_g, :H5E_CANTCLOSEOBJ_g, :hid_t

    attach_variable :H5E_COMPLEN_g, :H5E_COMPLEN_g, :hid_t

    attach_variable :H5E_PATH_g, :H5E_PATH_g, :hid_t

    attach_variable :H5E_NONE_MINOR_g, :H5E_NONE_MINOR_g, :hid_t

    attach_variable :H5E_OPENERROR_g, :H5E_OPENERROR_g, :hid_t

    attach_variable :H5E_FILEEXISTS_g, :H5E_FILEEXISTS_g, :hid_t

    attach_variable :H5E_FILEOPEN_g, :H5E_FILEOPEN_g, :hid_t

    attach_variable :H5E_CANTCREATE_g, :H5E_CANTCREATE_g, :hid_t

    attach_variable :H5E_CANTOPENFILE_g, :H5E_CANTOPENFILE_g, :hid_t

    attach_variable :H5E_CANTCLOSEFILE_g, :H5E_CANTCLOSEFILE_g, :hid_t

    attach_variable :H5E_NOTHDF5_g, :H5E_NOTHDF5_g, :hid_t

    attach_variable :H5E_BADFILE_g, :H5E_BADFILE_g, :hid_t

    attach_variable :H5E_TRUNCATED_g, :H5E_TRUNCATED_g, :hid_t

    attach_variable :H5E_MOUNT_g, :H5E_MOUNT_g, :hid_t

    attach_variable :H5E_UNMOUNT_g, :H5E_UNMOUNT_g, :hid_t

    attach_variable :H5E_CANTDELETEFILE_g, :H5E_CANTDELETEFILE_g, :hid_t

    attach_variable :H5E_CANTLOCKFILE_g, :H5E_CANTLOCKFILE_g, :hid_t

    attach_variable :H5E_CANTUNLOCKFILE_g, :H5E_CANTUNLOCKFILE_g, :hid_t

    attach_variable :H5E_CANTFLUSH_g, :H5E_CANTFLUSH_g, :hid_t

    attach_variable :H5E_CANTUNSERIALIZE_g, :H5E_CANTUNSERIALIZE_g, :hid_t

    attach_variable :H5E_CANTSERIALIZE_g, :H5E_CANTSERIALIZE_g, :hid_t

    attach_variable :H5E_CANTTAG_g, :H5E_CANTTAG_g, :hid_t

    attach_variable :H5E_CANTLOAD_g, :H5E_CANTLOAD_g, :hid_t

    attach_variable :H5E_PROTECT_g, :H5E_PROTECT_g, :hid_t

    attach_variable :H5E_NOTCACHED_g, :H5E_NOTCACHED_g, :hid_t

    attach_variable :H5E_SYSTEM_g, :H5E_SYSTEM_g, :hid_t

    attach_variable :H5E_CANTINS_g, :H5E_CANTINS_g, :hid_t

    attach_variable :H5E_CANTPROTECT_g, :H5E_CANTPROTECT_g, :hid_t

    attach_variable :H5E_CANTUNPROTECT_g, :H5E_CANTUNPROTECT_g, :hid_t

    attach_variable :H5E_CANTPIN_g, :H5E_CANTPIN_g, :hid_t

    attach_variable :H5E_CANTUNPIN_g, :H5E_CANTUNPIN_g, :hid_t

    attach_variable :H5E_CANTMARKDIRTY_g, :H5E_CANTMARKDIRTY_g, :hid_t

    attach_variable :H5E_CANTMARKCLEAN_g, :H5E_CANTMARKCLEAN_g, :hid_t

    attach_variable :H5E_CANTMARKUNSERIALIZED_g, :H5E_CANTMARKUNSERIALIZED_g, :hid_t

    attach_variable :H5E_CANTMARKSERIALIZED_g, :H5E_CANTMARKSERIALIZED_g, :hid_t

    attach_variable :H5E_CANTDIRTY_g, :H5E_CANTDIRTY_g, :hid_t

    attach_variable :H5E_CANTCLEAN_g, :H5E_CANTCLEAN_g, :hid_t

    attach_variable :H5E_CANTEXPUNGE_g, :H5E_CANTEXPUNGE_g, :hid_t

    attach_variable :H5E_CANTRESIZE_g, :H5E_CANTRESIZE_g, :hid_t

    attach_variable :H5E_CANTDEPEND_g, :H5E_CANTDEPEND_g, :hid_t

    attach_variable :H5E_CANTUNDEPEND_g, :H5E_CANTUNDEPEND_g, :hid_t

    attach_variable :H5E_CANTNOTIFY_g, :H5E_CANTNOTIFY_g, :hid_t

    attach_variable :H5E_LOGGING_g, :H5E_LOGGING_g, :hid_t

    attach_variable :H5E_CANTCORK_g, :H5E_CANTCORK_g, :hid_t

    attach_variable :H5E_CANTUNCORK_g, :H5E_CANTUNCORK_g, :hid_t

    attach_variable :H5E_TRAVERSE_g, :H5E_TRAVERSE_g, :hid_t

    attach_variable :H5E_NLINKS_g, :H5E_NLINKS_g, :hid_t

    attach_variable :H5E_NOTREGISTERED_g, :H5E_NOTREGISTERED_g, :hid_t

    attach_variable :H5E_CANTMOVE_g, :H5E_CANTMOVE_g, :hid_t

    attach_variable :H5E_CANTSORT_g, :H5E_CANTSORT_g, :hid_t

    attach_variable :H5E_MPI_g, :H5E_MPI_g, :hid_t

    attach_variable :H5E_MPIERRSTR_g, :H5E_MPIERRSTR_g, :hid_t

    attach_variable :H5E_CANTRECV_g, :H5E_CANTRECV_g, :hid_t

    attach_variable :H5E_CANTGATHER_g, :H5E_CANTGATHER_g, :hid_t

    attach_variable :H5E_NO_INDEPENDENT_g, :H5E_NO_INDEPENDENT_g, :hid_t

    attach_variable :H5E_CANTCLIP_g, :H5E_CANTCLIP_g, :hid_t

    attach_variable :H5E_CANTCOUNT_g, :H5E_CANTCOUNT_g, :hid_t

    attach_variable :H5E_CANTSELECT_g, :H5E_CANTSELECT_g, :hid_t

    attach_variable :H5E_CANTNEXT_g, :H5E_CANTNEXT_g, :hid_t

    attach_variable :H5E_BADSELECT_g, :H5E_BADSELECT_g, :hid_t

    attach_variable :H5E_CANTCOMPARE_g, :H5E_CANTCOMPARE_g, :hid_t

    attach_variable :H5E_INCONSISTENTSTATE_g, :H5E_INCONSISTENTSTATE_g, :hid_t

    attach_variable :H5E_CANTAPPEND_g, :H5E_CANTAPPEND_g, :hid_t

    attach_variable :H5E_UNINITIALIZED_g, :H5E_UNINITIALIZED_g, :hid_t

    attach_variable :H5E_UNSUPPORTED_g, :H5E_UNSUPPORTED_g, :hid_t

    attach_variable :H5E_BADTYPE_g, :H5E_BADTYPE_g, :hid_t

    attach_variable :H5E_BADRANGE_g, :H5E_BADRANGE_g, :hid_t

    attach_variable :H5E_BADVALUE_g, :H5E_BADVALUE_g, :hid_t

    attach_variable :H5E_NOTFOUND_g, :H5E_NOTFOUND_g, :hid_t

    attach_variable :H5E_EXISTS_g, :H5E_EXISTS_g, :hid_t

    attach_variable :H5E_CANTENCODE_g, :H5E_CANTENCODE_g, :hid_t

    attach_variable :H5E_CANTDECODE_g, :H5E_CANTDECODE_g, :hid_t

    attach_variable :H5E_CANTSPLIT_g, :H5E_CANTSPLIT_g, :hid_t

    attach_variable :H5E_CANTREDISTRIBUTE_g, :H5E_CANTREDISTRIBUTE_g, :hid_t

    attach_variable :H5E_CANTSWAP_g, :H5E_CANTSWAP_g, :hid_t

    attach_variable :H5E_CANTINSERT_g, :H5E_CANTINSERT_g, :hid_t

    attach_variable :H5E_CANTLIST_g, :H5E_CANTLIST_g, :hid_t

    attach_variable :H5E_CANTMODIFY_g, :H5E_CANTMODIFY_g, :hid_t

    attach_variable :H5E_CANTREMOVE_g, :H5E_CANTREMOVE_g, :hid_t

    attach_variable :H5E_CANTFIND_g, :H5E_CANTFIND_g, :hid_t

    attach_variable :H5E_CANTCONVERT_g, :H5E_CANTCONVERT_g, :hid_t

    attach_variable :H5E_BADSIZE_g, :H5E_BADSIZE_g, :hid_t

    enum :H5E_direction_t, [
      :H5E_WALK_UPWARD, 0,
      :H5E_WALK_DOWNWARD, 1
    ]

    typedef :H5E_direction_t, :H5E_direction_t

    typedef :pointer, :H5E_walk2_t

    typedef :pointer, :H5E_auto2_t

    attach_function 'H5Eregister_class', %i[
      string
      string
      string
    ], :hid_t

    attach_function 'H5Eunregister_class', [
      :hid_t
    ], :herr_t

    attach_function 'H5Eclose_msg', [
      :hid_t
    ], :herr_t

    attach_function 'H5Ecreate_msg', %i[
      hid_t
      H5E_type_t
      string
    ], :hid_t

    attach_function 'H5Ecreate_stack', [], :hid_t

    attach_function 'H5Eget_current_stack', [], :hid_t

    attach_function 'H5Eappend_stack', %i[
      hid_t
      hid_t
      hbool_t
    ], :herr_t

    attach_function 'H5Eclose_stack', [
      :hid_t
    ], :herr_t

    attach_function 'H5Eget_class_name', %i[
      hid_t
      string
      size_t
    ], :ssize_t

    attach_function 'H5Eset_current_stack', [
      :hid_t
    ], :herr_t

    attach_function 'H5Epush2', %i[
      hid_t
      string
      string
      uint
      hid_t
      hid_t
      hid_t
      string
    ], :herr_t

    attach_function 'H5Epop', %i[
      hid_t
      size_t
    ], :herr_t

    attach_function 'H5Eprint2', [
      :hid_t,
      FILE.ptr
    ], :herr_t

    attach_function 'H5Ewalk2', %i[
      hid_t
      H5E_direction_t
      H5E_walk2_t
      pointer
    ], :herr_t

    attach_function 'H5Eget_auto2', %i[
      hid_t
      pointer
      pointer
    ], :herr_t

    attach_function 'H5Eset_auto2', %i[
      hid_t
      H5E_auto2_t
      pointer
    ], :herr_t

    attach_function 'H5Eclear2', [
      :hid_t
    ], :herr_t

    attach_function 'H5Eauto_is_v2', %i[
      hid_t
      pointer
    ], :herr_t

    attach_function 'H5Eget_msg', %i[
      hid_t
      pointer
      string
      size_t
    ], :ssize_t

    attach_function 'H5Eget_num', [
      :hid_t
    ], :ssize_t

    typedef :hid_t, :H5E_major_t

    typedef :hid_t, :H5E_minor_t

    class H5EError1T < ::FFI::Struct
      layout \
        :maj_num, :H5E_major_t,
        :min_num, :H5E_minor_t,
        :func_name, :string,
        :file_name, :string,
        :line, :uint,
        :desc, :string
    end

    # H5EError1T = H5EError1T

    typedef :pointer, :H5E_walk1_t

    typedef :pointer, :H5E_auto1_t

    attach_function 'H5Eclear1', [], :herr_t

    attach_function 'H5Eget_auto1', %i[
      pointer
      pointer
    ], :herr_t

    attach_function 'H5Epush1', %i[
      string
      string
      uint
      H5E_major_t
      H5E_minor_t
      string
    ], :herr_t

    attach_function 'H5Eprint1', [
      FILE.ptr
    ], :herr_t

    attach_function 'H5Eset_auto1', %i[
      H5E_auto1_t
      pointer
    ], :herr_t

    attach_function 'H5Ewalk1', %i[
      H5E_direction_t
      H5E_walk1_t
      pointer
    ], :herr_t

    attach_function 'H5Eget_major', [
      :H5E_major_t
    ], :string

    attach_function 'H5Eget_minor', [
      :H5E_minor_t
    ], :string

    enum :H5ES_status_t, [
      :H5ES_STATUS_IN_PROGRESS, 0,
      :H5ES_STATUS_SUCCEED, 1,
      :H5ES_STATUS_CANCELED, 2,
      :H5ES_STATUS_FAIL, 3
    ]

    typedef :H5ES_status_t, :H5ES_status_t

    class H5ESOpInfoT < ::FFI::Struct
      layout \
        :api_name, :string,
        :api_args, :string,
        :app_file_name, :string,
        :app_func_name, :string,
        :app_line_num, :uint,
        :op_ins_count, :uint64_t,
        :op_ins_ts, :uint64_t,
        :op_exec_ts, :uint64_t,
        :op_exec_time, :uint64_t
    end

    # H5ESOpInfoT = H5ESOpInfoT

    class H5ESErrInfoT < ::FFI::Struct
      layout \
        :api_name, :string,
        :api_args, :string,
        :app_file_name, :string,
        :app_func_name, :string,
        :app_line_num, :uint,
        :op_ins_count, :uint64_t,
        :op_ins_ts, :uint64_t,
        :op_exec_ts, :uint64_t,
        :op_exec_time, :uint64_t,
        :err_stack_id, :hid_t
    end

    # H5ESErrInfoT = H5ESErrInfoT

    typedef :pointer, :H5ES_event_insert_func_t

    typedef :pointer, :H5ES_event_complete_func_t

    attach_function 'H5EScreate', [], :hid_t

    attach_function 'H5ESwait', %i[
      hid_t
      uint64_t
      pointer
      pointer
    ], :herr_t

    attach_function 'H5EScancel', %i[
      hid_t
      pointer
      pointer
    ], :herr_t

    attach_function 'H5ESget_count', %i[
      hid_t
      pointer
    ], :herr_t

    attach_function 'H5ESget_op_counter', %i[
      hid_t
      pointer
    ], :herr_t

    attach_function 'H5ESget_err_status', %i[
      hid_t
      pointer
    ], :herr_t

    attach_function 'H5ESget_err_count', %i[
      hid_t
      pointer
    ], :herr_t

    attach_function 'H5ESget_err_info', [
      :hid_t,
      :size_t,
      H5ESErrInfoT.ptr,
      :pointer
    ], :herr_t

    attach_function 'H5ESfree_err_info', [
      :size_t,
      H5ESErrInfoT.ptr
    ], :herr_t

    attach_function 'H5ESregister_insert_func', %i[
      hid_t
      H5ES_event_insert_func_t
      pointer
    ], :herr_t

    attach_function 'H5ESregister_complete_func', %i[
      hid_t
      H5ES_event_complete_func_t
      pointer
    ], :herr_t

    attach_function 'H5ESclose', [
      :hid_t
    ], :herr_t

    enum :H5F_scope_t, [
      :H5F_SCOPE_LOCAL, 0,
      :H5F_SCOPE_GLOBAL, 1
    ]

    typedef :H5F_scope_t, :H5F_scope_t

    enum :H5F_close_degree_t, [
      :H5F_CLOSE_DEFAULT, 0,
      :H5F_CLOSE_WEAK, 1,
      :H5F_CLOSE_SEMI, 2,
      :H5F_CLOSE_STRONG, 3
    ]

    typedef :H5F_close_degree_t, :H5F_close_degree_t

    class Anon_Type_25 < ::FFI::Struct
      layout \
        :version, :uint,
        :super_size, :hsize_t,
        :super_ext_size, :hsize_t
    end

    class Anon_Type_26 < ::FFI::Struct
      layout \
        :version, :uint,
        :meta_size, :hsize_t,
        :tot_space, :hsize_t
    end

    class Anon_Type_27 < ::FFI::Struct
      layout \
        :version, :uint,
        :hdr_size, :hsize_t,
        :msgs_info, H5IhInfoT
    end

    class H5FInfo2T < ::FFI::Struct
      layout \
        :super, Anon_Type_25,
        :free, Anon_Type_26,
        :sohm, Anon_Type_27
    end

    # H5FInfo2T = H5FInfo2T

    enum :H5F_mem_t, [
      :H5FD_MEM_NOLIST, 4_294_967_295,
      :H5FD_MEM_DEFAULT, 0,
      :H5FD_MEM_SUPER, 1,
      :H5FD_MEM_BTREE, 2,
      :H5FD_MEM_DRAW, 3,
      :H5FD_MEM_GHEAP, 4,
      :H5FD_MEM_LHEAP, 5,
      :H5FD_MEM_OHDR, 6,
      :H5FD_MEM_NTYPES, 7
    ]

    typedef :H5F_mem_t, :H5F_mem_t

    class H5FSectInfoT < ::FFI::Struct
      layout \
        :addr, :haddr_t,
        :size, :hsize_t
    end

    # H5FSectInfoT = H5FSectInfoT

    enum :H5F_libver_t, [
      :H5F_LIBVER_ERROR, 4_294_967_295,
      :H5F_LIBVER_EARLIEST, 0,
      :H5F_LIBVER_V18, 1,
      :H5F_LIBVER_V110, 2,
      :H5F_LIBVER_V112, 3,
      :H5F_LIBVER_V114, 4,
      :H5F_LIBVER_NBOUNDS, 5
    ]

    typedef :H5F_libver_t, :H5F_libver_t

    enum :H5F_fspace_strategy_t, [
      :H5F_FSPACE_STRATEGY_FSM_AGGR, 0,
      :H5F_FSPACE_STRATEGY_PAGE, 1,
      :H5F_FSPACE_STRATEGY_AGGR, 2,
      :H5F_FSPACE_STRATEGY_NONE, 3,
      :H5F_FSPACE_STRATEGY_NTYPES, 4
    ]

    typedef :H5F_fspace_strategy_t, :H5F_fspace_strategy_t

    enum :H5F_file_space_type_t, [
      :H5F_FILE_SPACE_DEFAULT, 0,
      :H5F_FILE_SPACE_ALL_PERSIST, 1,
      :H5F_FILE_SPACE_ALL, 2,
      :H5F_FILE_SPACE_AGGR_VFD, 3,
      :H5F_FILE_SPACE_VFD, 4,
      :H5F_FILE_SPACE_NTYPES, 5
    ]

    typedef :H5F_file_space_type_t, :H5F_file_space_type_t

    class H5FRetryInfoT < ::FFI::Struct
      layout \
        :nbins, :uint,
        :retries, [:pointer, 21]
    end

    # H5FRetryInfoT = H5FRetryInfoT

    typedef :pointer, :H5F_flush_cb_t

    attach_function 'H5Fis_accessible', %i[
      string
      hid_t
    ], :htri_t

    attach_function 'H5Fcreate', %i[
      string
      uint
      hid_t
      hid_t
    ], :hid_t

    attach_function 'H5Fcreate_async', %i[
      string
      string
      uint
      string
      uint
      hid_t
      hid_t
      hid_t
    ], :hid_t

    attach_function 'H5Fopen', %i[
      string
      uint
      hid_t
    ], :hid_t

    attach_function 'H5Fopen_async', %i[
      string
      string
      uint
      string
      uint
      hid_t
      hid_t
    ], :hid_t

    attach_function 'H5Freopen', [
      :hid_t
    ], :hid_t

    attach_function 'H5Freopen_async', %i[
      string
      string
      uint
      hid_t
      hid_t
    ], :hid_t

    attach_function 'H5Fflush', %i[
      hid_t
      H5F_scope_t
    ], :herr_t

    attach_function 'H5Fflush_async', %i[
      string
      string
      uint
      hid_t
      H5F_scope_t
      hid_t
    ], :herr_t

    attach_function 'H5Fclose', [
      :hid_t
    ], :herr_t

    attach_function 'H5Fclose_async', %i[
      string
      string
      uint
      hid_t
      hid_t
    ], :herr_t

    attach_function 'H5Fdelete', %i[
      string
      hid_t
    ], :herr_t

    attach_function 'H5Fget_create_plist', [
      :hid_t
    ], :hid_t

    attach_function 'H5Fget_access_plist', [
      :hid_t
    ], :hid_t

    attach_function 'H5Fget_intent', %i[
      hid_t
      pointer
    ], :herr_t

    attach_function 'H5Fget_fileno', %i[
      hid_t
      pointer
    ], :herr_t

    attach_function 'H5Fget_obj_count', %i[
      hid_t
      uint
    ], :ssize_t

    attach_function 'H5Fget_obj_ids', %i[
      hid_t
      uint
      size_t
      pointer
    ], :ssize_t

    attach_function 'H5Fget_vfd_handle', %i[
      hid_t
      hid_t
      pointer
    ], :herr_t

    attach_function 'H5Fmount', %i[
      hid_t
      string
      hid_t
      hid_t
    ], :herr_t

    attach_function 'H5Funmount', %i[
      hid_t
      string
    ], :herr_t

    attach_function 'H5Fget_freespace', [
      :hid_t
    ], :hssize_t

    attach_function 'H5Fget_filesize', %i[
      hid_t
      pointer
    ], :herr_t

    attach_function 'H5Fget_eoa', %i[
      hid_t
      pointer
    ], :herr_t

    attach_function 'H5Fincrement_filesize', %i[
      hid_t
      hsize_t
    ], :herr_t

    attach_function 'H5Fget_file_image', %i[
      hid_t
      pointer
      size_t
    ], :ssize_t

    attach_function 'H5Fget_mdc_config', [
      :hid_t,
      H5ACCacheConfigT.ptr
    ], :herr_t

    attach_function 'H5Fset_mdc_config', [
      :hid_t,
      H5ACCacheConfigT.ptr
    ], :herr_t

    attach_function 'H5Fget_mdc_hit_rate', %i[
      hid_t
      pointer
    ], :herr_t

    attach_function 'H5Fget_mdc_size', %i[
      hid_t
      pointer
      pointer
      pointer
      pointer
    ], :herr_t

    attach_function 'H5Freset_mdc_hit_rate_stats', [
      :hid_t
    ], :herr_t

    attach_function 'H5Fget_name', %i[
      hid_t
      string
      size_t
    ], :ssize_t

    attach_function 'H5Fget_info2', [
      :hid_t,
      H5FInfo2T.ptr
    ], :herr_t

    attach_function 'H5Fget_metadata_read_retry_info', [
      :hid_t,
      H5FRetryInfoT.ptr
    ], :herr_t

    attach_function 'H5Fstart_swmr_write', [
      :hid_t
    ], :herr_t

    attach_function 'H5Fget_free_sections', [
      :hid_t,
      :H5F_mem_t,
      :size_t,
      H5FSectInfoT.ptr
    ], :ssize_t

    attach_function 'H5Fclear_elink_file_cache', [
      :hid_t
    ], :herr_t

    attach_function 'H5Fset_libver_bounds', %i[
      hid_t
      H5F_libver_t
      H5F_libver_t
    ], :herr_t

    attach_function 'H5Fstart_mdc_logging', [
      :hid_t
    ], :herr_t

    attach_function 'H5Fstop_mdc_logging', [
      :hid_t
    ], :herr_t

    attach_function 'H5Fget_mdc_logging_status', %i[
      hid_t
      pointer
      pointer
    ], :herr_t

    attach_function 'H5Freset_page_buffering_stats', [
      :hid_t
    ], :herr_t

    attach_function 'H5Fget_page_buffering_stats', [
      :hid_t,
      :pointer, # [:uint, 2]
      :pointer, # [:uint, 2]
      :pointer, # [:uint, 2]
      :pointer, # [:uint, 2]
      :pointer # [:uint, 2]
    ], :herr_t

    attach_function 'H5Fget_mdc_image_info', %i[
      hid_t
      pointer
      pointer
    ], :herr_t

    attach_function 'H5Fget_dset_no_attrs_hint', %i[
      hid_t
      pointer
    ], :herr_t

    attach_function 'H5Fset_dset_no_attrs_hint', %i[
      hid_t
      hbool_t
    ], :herr_t

    attach_function 'H5Fformat_convert', [
      :hid_t
    ], :herr_t

    class Anon_Type_28 < ::FFI::Struct
      layout \
        :hdr_size, :hsize_t,
        :msgs_info, H5IhInfoT
    end

    class H5FInfo1T < ::FFI::Struct
      layout \
        :super_ext_size, :hsize_t,
        :sohm, Anon_Type_28
    end

    # H5FInfo1T = H5FInfo1T

    attach_function 'H5Fget_info1', [
      :hid_t,
      H5FInfo1T.ptr
    ], :herr_t

    attach_function 'H5Fset_latest_format', %i[
      hid_t
      hbool_t
    ], :herr_t

    attach_function 'H5Fis_hdf5', [
      :string
    ], :htri_t

    typedef :int, :H5FD_class_value_t

    typedef :H5F_mem_t, :H5FD_mem_t

    enum :anon_enum_63, [
      :H5FD_FILE_IMAGE_OP_NO_OP, 0,
      :H5FD_FILE_IMAGE_OP_PROPERTY_LIST_SET, 1,
      :H5FD_FILE_IMAGE_OP_PROPERTY_LIST_COPY, 2,
      :H5FD_FILE_IMAGE_OP_PROPERTY_LIST_GET, 3,
      :H5FD_FILE_IMAGE_OP_PROPERTY_LIST_CLOSE, 4,
      :H5FD_FILE_IMAGE_OP_FILE_OPEN, 5,
      :H5FD_FILE_IMAGE_OP_FILE_RESIZE, 6,
      :H5FD_FILE_IMAGE_OP_FILE_CLOSE, 7
    ]

    typedef :anon_enum_63, :H5FD_file_image_op_t

    class Anon_Type_29 < ::FFI::Struct
      layout \
        :image_malloc, :pointer,
        :image_memcpy, :pointer,
        :image_realloc, :pointer,
        :image_free, :pointer,
        :udata_copy, :pointer,
        :udata_free, :pointer,
        :udata, :pointer
    end

    H5FDFileImageCallbacksT = Anon_Type_29

    class H5FDCtlMemcpyArgsT < ::FFI::Struct
      layout \
        :dstbuf, :pointer,
        :dst_off, :hsize_t,
        :srcbuf, :pointer,
        :src_off, :hsize_t,
        :len, :size_t
    end

    # H5FDCtlMemcpyArgsT = H5FDCtlMemcpyArgsT

    attach_function 'H5FDdriver_query', %i[
      hid_t
      pointer
    ], :herr_t

    enum :anon_enum_66, [
      :H5L_TYPE_ERROR, 4_294_967_295,
      :H5L_TYPE_HARD, 0,
      :H5L_TYPE_SOFT, 1,
      :H5L_TYPE_EXTERNAL, 64,
      :H5L_TYPE_MAX, 255
    ]

    typedef :anon_enum_66, :H5L_type_t

    class Anon_Type_31 < ::FFI::Union
      layout \
        :token, H5OTokenT,
        :val_size, :size_t
    end

    class Anon_Type_30 < ::FFI::Struct
      layout \
        :type, :H5L_type_t,
        :corder_valid, :hbool_t,
        :corder, :int64_t,
        :cset, :H5T_cset_t,
        :u, Anon_Type_31
    end

    H5LInfo2T = Anon_Type_30

    typedef :pointer, :H5L_iterate2_t

    typedef :pointer, :H5L_elink_traverse_t

    attach_function 'H5Lmove', %i[
      hid_t
      string
      hid_t
      string
      hid_t
      hid_t
    ], :herr_t

    attach_function 'H5Lcopy', %i[
      hid_t
      string
      hid_t
      string
      hid_t
      hid_t
    ], :herr_t

    attach_function 'H5Lcreate_hard', %i[
      hid_t
      string
      hid_t
      string
      hid_t
      hid_t
    ], :herr_t

    attach_function 'H5Lcreate_hard_async', %i[
      string
      string
      uint
      hid_t
      string
      hid_t
      string
      hid_t
      hid_t
      hid_t
    ], :herr_t

    attach_function 'H5Lcreate_soft', %i[
      string
      hid_t
      string
      hid_t
      hid_t
    ], :herr_t

    attach_function 'H5Lcreate_soft_async', %i[
      string
      string
      uint
      string
      hid_t
      string
      hid_t
      hid_t
      hid_t
    ], :herr_t

    attach_function 'H5Ldelete', %i[
      hid_t
      string
      hid_t
    ], :herr_t

    attach_function 'H5Ldelete_async', %i[
      string
      string
      uint
      hid_t
      string
      hid_t
      hid_t
    ], :herr_t

    attach_function 'H5Ldelete_by_idx', %i[
      hid_t
      string
      H5_index_t
      H5_iter_order_t
      hsize_t
      hid_t
    ], :herr_t

    attach_function 'H5Ldelete_by_idx_async', %i[
      string
      string
      uint
      hid_t
      string
      H5_index_t
      H5_iter_order_t
      hsize_t
      hid_t
      hid_t
    ], :herr_t

    attach_function 'H5Lget_val', %i[
      hid_t
      string
      pointer
      size_t
      hid_t
    ], :herr_t

    attach_function 'H5Lget_val_by_idx', %i[
      hid_t
      string
      H5_index_t
      H5_iter_order_t
      hsize_t
      pointer
      size_t
      hid_t
    ], :herr_t

    attach_function 'H5Lexists', %i[
      hid_t
      string
      hid_t
    ], :htri_t

    attach_function 'H5Lexists_async', %i[
      string
      string
      uint
      hid_t
      string
      pointer
      hid_t
      hid_t
    ], :herr_t

    attach_function 'H5Lget_info2', [
      :hid_t,
      :string,
      H5LInfo2T.ptr,
      :hid_t
    ], :herr_t

    attach_function 'H5Lget_info_by_idx2', [
      :hid_t,
      :string,
      :H5_index_t,
      :H5_iter_order_t,
      :hsize_t,
      H5LInfo2T.ptr,
      :hid_t
    ], :herr_t

    attach_function 'H5Lget_name_by_idx', %i[
      hid_t
      string
      H5_index_t
      H5_iter_order_t
      hsize_t
      string
      size_t
      hid_t
    ], :ssize_t

    attach_function 'H5Literate2', %i[
      hid_t
      H5_index_t
      H5_iter_order_t
      pointer
      H5L_iterate2_t
      pointer
    ], :herr_t

    attach_function 'H5Literate_async', %i[
      string
      string
      uint
      hid_t
      H5_index_t
      H5_iter_order_t
      pointer
      H5L_iterate2_t
      pointer
      hid_t
    ], :herr_t

    attach_function 'H5Literate_by_name2', %i[
      hid_t
      string
      H5_index_t
      H5_iter_order_t
      pointer
      H5L_iterate2_t
      pointer
      hid_t
    ], :herr_t

    attach_function 'H5Lvisit2', %i[
      hid_t
      H5_index_t
      H5_iter_order_t
      H5L_iterate2_t
      pointer
    ], :herr_t

    attach_function 'H5Lvisit_by_name2', %i[
      hid_t
      string
      H5_index_t
      H5_iter_order_t
      H5L_iterate2_t
      pointer
      hid_t
    ], :herr_t

    attach_function 'H5Lcreate_ud', %i[
      hid_t
      string
      H5L_type_t
      pointer
      size_t
      hid_t
      hid_t
    ], :herr_t

    attach_function 'H5Lis_registered', [
      :H5L_type_t
    ], :htri_t

    attach_function 'H5Lunpack_elink_val', %i[
      pointer
      size_t
      pointer
      pointer
      pointer
    ], :herr_t

    attach_function 'H5Lcreate_external', %i[
      string
      string
      hid_t
      string
      hid_t
      hid_t
    ], :herr_t

    class Anon_Type_33 < ::FFI::Union
      layout \
        :address, :haddr_t,
        :val_size, :size_t
    end

    class Anon_Type_32 < ::FFI::Struct
      layout \
        :type, :H5L_type_t,
        :corder_valid, :hbool_t,
        :corder, :int64_t,
        :cset, :H5T_cset_t,
        :u, Anon_Type_33
    end

    H5LInfo1T = Anon_Type_32

    typedef :pointer, :H5L_iterate1_t

    attach_function 'H5Lget_info1', [
      :hid_t,
      :string,
      H5LInfo1T.ptr,
      :hid_t
    ], :herr_t

    attach_function 'H5Lget_info_by_idx1', [
      :hid_t,
      :string,
      :H5_index_t,
      :H5_iter_order_t,
      :hsize_t,
      H5LInfo1T.ptr,
      :hid_t
    ], :herr_t

    attach_function 'H5Literate1', %i[
      hid_t
      H5_index_t
      H5_iter_order_t
      pointer
      H5L_iterate1_t
      pointer
    ], :herr_t

    attach_function 'H5Literate_by_name1', %i[
      hid_t
      string
      H5_index_t
      H5_iter_order_t
      pointer
      H5L_iterate1_t
      pointer
      hid_t
    ], :herr_t

    attach_function 'H5Lvisit1', %i[
      hid_t
      H5_index_t
      H5_iter_order_t
      H5L_iterate1_t
      pointer
    ], :herr_t

    attach_function 'H5Lvisit_by_name1', %i[
      hid_t
      string
      H5_index_t
      H5_iter_order_t
      H5L_iterate1_t
      pointer
      hid_t
    ], :herr_t

    enum :H5G_storage_type_t, [
      :H5G_STORAGE_TYPE_UNKNOWN, 4_294_967_295,
      :H5G_STORAGE_TYPE_SYMBOL_TABLE, 0,
      :H5G_STORAGE_TYPE_COMPACT, 1,
      :H5G_STORAGE_TYPE_DENSE, 2
    ]

    typedef :H5G_storage_type_t, :H5G_storage_type_t

    class H5GInfoT < ::FFI::Struct
      layout \
        :storage_type, :H5G_storage_type_t,
        :nlinks, :hsize_t,
        :max_corder, :int64_t,
        :mounted, :hbool_t
    end

    # H5GInfoT = H5GInfoT

    attach_function 'H5Gcreate2', %i[
      hid_t
      string
      hid_t
      hid_t
      hid_t
    ], :hid_t

    attach_function 'H5Gcreate_async', %i[
      string
      string
      uint
      hid_t
      string
      hid_t
      hid_t
      hid_t
      hid_t
    ], :hid_t

    attach_function 'H5Gcreate_anon', %i[
      hid_t
      hid_t
      hid_t
    ], :hid_t

    attach_function 'H5Gopen2', %i[
      hid_t
      string
      hid_t
    ], :hid_t

    attach_function 'H5Gopen_async', %i[
      string
      string
      uint
      hid_t
      string
      hid_t
      hid_t
    ], :hid_t

    attach_function 'H5Gget_create_plist', [
      :hid_t
    ], :hid_t

    attach_function 'H5Gget_info', [
      :hid_t,
      H5GInfoT.ptr
    ], :herr_t

    attach_function 'H5Gget_info_async', [
      :string,
      :string,
      :uint,
      :hid_t,
      H5GInfoT.ptr,
      :hid_t
    ], :herr_t

    attach_function 'H5Gget_info_by_name', [
      :hid_t,
      :string,
      H5GInfoT.ptr,
      :hid_t
    ], :herr_t

    attach_function 'H5Gget_info_by_name_async', [
      :string,
      :string,
      :uint,
      :hid_t,
      :string,
      H5GInfoT.ptr,
      :hid_t,
      :hid_t
    ], :herr_t

    attach_function 'H5Gget_info_by_idx', [
      :hid_t,
      :string,
      :H5_index_t,
      :H5_iter_order_t,
      :hsize_t,
      H5GInfoT.ptr,
      :hid_t
    ], :herr_t

    attach_function 'H5Gget_info_by_idx_async', [
      :string,
      :string,
      :uint,
      :hid_t,
      :string,
      :H5_index_t,
      :H5_iter_order_t,
      :hsize_t,
      H5GInfoT.ptr,
      :hid_t,
      :hid_t
    ], :herr_t

    attach_function 'H5Gflush', [
      :hid_t
    ], :herr_t

    attach_function 'H5Grefresh', [
      :hid_t
    ], :herr_t

    attach_function 'H5Gclose', [
      :hid_t
    ], :herr_t

    attach_function 'H5Gclose_async', %i[
      string
      string
      uint
      hid_t
      hid_t
    ], :herr_t

    enum :H5G_obj_t, [
      :H5G_UNKNOWN, 4_294_967_295,
      :H5G_GROUP, 0,
      :H5G_DATASET, 1,
      :H5G_TYPE, 2,
      :H5G_LINK, 3,
      :H5G_UDLINK, 4,
      :H5G_RESERVED_5, 5,
      :H5G_RESERVED_6, 6,
      :H5G_RESERVED_7, 7
    ]

    typedef :H5G_obj_t, :H5G_obj_t

    typedef :pointer, :H5G_iterate_t

    class H5GStatT < ::FFI::Struct
      layout \
        :fileno, [:ulong, 2],
        :objno, [:ulong, 2],
        :nlink, :uint,
        :type, :H5G_obj_t,
        :mtime, :time_t,
        :linklen, :size_t,
        :ohdr, H5OStatT
    end

    # H5GStatT = H5GStatT

    attach_function 'H5Gcreate1', %i[
      hid_t
      string
      size_t
    ], :hid_t

    attach_function 'H5Gopen1', %i[
      hid_t
      string
    ], :hid_t

    attach_function 'H5Glink', %i[
      hid_t
      H5L_type_t
      string
      string
    ], :herr_t

    attach_function 'H5Glink2', %i[
      hid_t
      string
      H5L_type_t
      hid_t
      string
    ], :herr_t

    attach_function 'H5Gmove', %i[
      hid_t
      string
      string
    ], :herr_t

    attach_function 'H5Gmove2', %i[
      hid_t
      string
      hid_t
      string
    ], :herr_t

    attach_function 'H5Gunlink', %i[
      hid_t
      string
    ], :herr_t

    attach_function 'H5Gget_linkval', %i[
      hid_t
      string
      size_t
      string
    ], :herr_t

    attach_function 'H5Gset_comment', %i[
      hid_t
      string
      string
    ], :herr_t

    attach_function 'H5Gget_comment', %i[
      hid_t
      string
      size_t
      string
    ], :int

    attach_function 'H5Giterate', %i[
      hid_t
      string
      pointer
      H5G_iterate_t
      pointer
    ], :herr_t

    attach_function 'H5Gget_num_objs', %i[
      hid_t
      pointer
    ], :herr_t

    attach_function 'H5Gget_objinfo', [
      :hid_t,
      :string,
      :hbool_t,
      H5GStatT.ptr
    ], :herr_t

    attach_function 'H5Gget_objname_by_idx', %i[
      hid_t
      hsize_t
      string
      size_t
    ], :ssize_t

    attach_function 'H5Gget_objtype_by_idx', %i[
      hid_t
      hsize_t
    ], :H5G_obj_t

    typedef :int, :H5VL_class_value_t

    enum :H5VL_subclass_t, [
      :H5VL_SUBCLS_NONE, 0,
      :H5VL_SUBCLS_INFO, 1,
      :H5VL_SUBCLS_WRAP, 2,
      :H5VL_SUBCLS_ATTR, 3,
      :H5VL_SUBCLS_DATASET, 4,
      :H5VL_SUBCLS_DATATYPE, 5,
      :H5VL_SUBCLS_FILE, 6,
      :H5VL_SUBCLS_GROUP, 7,
      :H5VL_SUBCLS_LINK, 8,
      :H5VL_SUBCLS_OBJECT, 9,
      :H5VL_SUBCLS_REQUEST, 10,
      :H5VL_SUBCLS_BLOB, 11,
      :H5VL_SUBCLS_TOKEN, 12
    ]

    typedef :H5VL_subclass_t, :H5VL_subclass_t

    attach_function 'H5VLregister_connector_by_name', %i[
      string
      hid_t
    ], :hid_t

    attach_function 'H5VLregister_connector_by_value', %i[
      H5VL_class_value_t
      hid_t
    ], :hid_t

    attach_function 'H5VLis_connector_registered_by_name', [
      :string
    ], :htri_t

    attach_function 'H5VLis_connector_registered_by_value', [
      :H5VL_class_value_t
    ], :htri_t

    attach_function 'H5VLget_connector_id', [
      :hid_t
    ], :hid_t

    attach_function 'H5VLget_connector_id_by_name', [
      :string
    ], :hid_t

    attach_function 'H5VLget_connector_id_by_value', [
      :H5VL_class_value_t
    ], :hid_t

    attach_function 'H5VLget_connector_name', %i[
      hid_t
      string
      size_t
    ], :ssize_t

    attach_function 'H5VLclose', [
      :hid_t
    ], :herr_t

    attach_function 'H5VLunregister_connector', [
      :hid_t
    ], :herr_t

    attach_function 'H5VLquery_optional', %i[
      hid_t
      H5VL_subclass_t
      int
      pointer
    ], :herr_t

    attach_function 'H5VLobject_is_native', %i[
      hid_t
      pointer
    ], :herr_t

    enum :anon_enum_73, [
      :H5R_BADTYPE, 4_294_967_295,
      :H5R_OBJECT1, 0,
      :H5R_DATASET_REGION1, 1,
      :H5R_OBJECT2, 2,
      :H5R_DATASET_REGION2, 3,
      :H5R_ATTR, 4,
      :H5R_MAXTYPE, 5
    ]

    typedef :anon_enum_73, :H5R_type_t

    typedef :haddr_t, :hobj_ref_t

    class Anon_Type_34 < ::FFI::Struct
      layout \
        :__data, [:uint8_t, 12]
    end

    HdsetRegRefT = Anon_Type_34

    class Anon_Type_36 < ::FFI::Union
      layout \
        :__data, [:uint8_t, 64],
        :align, :int64_t
    end

    class Anon_Type_35 < ::FFI::Struct
      layout \
        :u, Anon_Type_36
    end

    H5RRefT = Anon_Type_35

    attach_function 'H5Rcreate_object', [
      :hid_t,
      :string,
      :hid_t,
      H5RRefT.ptr
    ], :herr_t

    attach_function 'H5Rcreate_region', [
      :hid_t,
      :string,
      :hid_t,
      :hid_t,
      H5RRefT.ptr
    ], :herr_t

    attach_function 'H5Rcreate_attr', [
      :hid_t,
      :string,
      :string,
      :hid_t,
      H5RRefT.ptr
    ], :herr_t

    attach_function 'H5Rdestroy', [
      H5RRefT.ptr
    ], :herr_t

    attach_function 'H5Rget_type', [
      H5RRefT.ptr
    ], :H5R_type_t

    attach_function 'H5Requal', [
      H5RRefT.ptr,
      H5RRefT.ptr
    ], :htri_t

    attach_function 'H5Rcopy', [
      H5RRefT.ptr,
      H5RRefT.ptr
    ], :herr_t

    attach_function 'H5Ropen_object', [
      H5RRefT.ptr,
      :hid_t,
      :hid_t
    ], :hid_t

    attach_function 'H5Ropen_object_async', [
      :string,
      :string,
      :uint,
      H5RRefT.ptr,
      :hid_t,
      :hid_t,
      :hid_t
    ], :hid_t

    attach_function 'H5Ropen_region', [
      H5RRefT.ptr,
      :hid_t,
      :hid_t
    ], :hid_t

    attach_function 'H5Ropen_region_async', [
      :string,
      :string,
      :uint,
      H5RRefT.ptr,
      :hid_t,
      :hid_t,
      :hid_t
    ], :hid_t

    attach_function 'H5Ropen_attr', [
      H5RRefT.ptr,
      :hid_t,
      :hid_t
    ], :hid_t

    attach_function 'H5Ropen_attr_async', [
      :string,
      :string,
      :uint,
      H5RRefT.ptr,
      :hid_t,
      :hid_t,
      :hid_t
    ], :hid_t

    attach_function 'H5Rget_obj_type3', [
      H5RRefT.ptr,
      :hid_t,
      :pointer
    ], :herr_t

    attach_function 'H5Rget_file_name', [
      H5RRefT.ptr,
      :string,
      :size_t
    ], :ssize_t

    attach_function 'H5Rget_obj_name', [
      H5RRefT.ptr,
      :hid_t,
      :string,
      :size_t
    ], :ssize_t

    attach_function 'H5Rget_attr_name', [
      H5RRefT.ptr,
      :string,
      :size_t
    ], :ssize_t

    attach_function 'H5Rget_obj_type1', %i[
      hid_t
      H5R_type_t
      pointer
    ], :H5G_obj_t

    attach_function 'H5Rdereference1', %i[
      hid_t
      H5R_type_t
      pointer
    ], :hid_t

    attach_function 'H5Rcreate', %i[
      pointer
      hid_t
      string
      H5R_type_t
      hid_t
    ], :herr_t

    attach_function 'H5Rget_obj_type2', %i[
      hid_t
      H5R_type_t
      pointer
      pointer
    ], :herr_t

    attach_function 'H5Rdereference2', %i[
      hid_t
      hid_t
      H5R_type_t
      pointer
    ], :hid_t

    attach_function 'H5Rget_region', %i[
      hid_t
      H5R_type_t
      pointer
    ], :hid_t

    attach_function 'H5Rget_name', %i[
      hid_t
      H5R_type_t
      pointer
      string
      size_t
    ], :ssize_t

    enum :H5VL_loc_type_t, [
      :H5VL_OBJECT_BY_SELF, 0,
      :H5VL_OBJECT_BY_NAME, 1,
      :H5VL_OBJECT_BY_IDX, 2,
      :H5VL_OBJECT_BY_TOKEN, 3
    ]

    typedef :H5VL_loc_type_t, :H5VL_loc_type_t

    class H5VLLocByName < ::FFI::Struct
      layout \
        :name, :string,
        :lapl_id, :hid_t
    end

    H5VLLocByNameT = H5VLLocByName

    class H5VLLocByIdx < ::FFI::Struct
      layout \
        :name, :string,
        :idx_type, :H5_index_t,
        :order, :H5_iter_order_t,
        :n, :hsize_t,
        :lapl_id, :hid_t
    end

    H5VLLocByIdxT = H5VLLocByIdx

    class H5VLLocByToken < ::FFI::Struct
      layout \
        :token, H5OTokenT.ptr
    end

    H5VLLocByTokenT = H5VLLocByToken

    class Anon_Type_37 < ::FFI::Union
      layout \
        :loc_by_token, H5VLLocByTokenT,
        :loc_by_name, H5VLLocByNameT,
        :loc_by_idx, H5VLLocByIdxT
    end

    class H5VLLocParamsT < ::FFI::Struct
      layout \
        :obj_type, :H5I_type_t,
        :type, :H5VL_loc_type_t,
        :loc_data, Anon_Type_37
    end

    # H5VLLocParamsT = H5VLLocParamsT

    class H5VLOptionalArgsT < ::FFI::Struct
      layout \
        :op_type, :int,
        :args, :pointer
    end

    # H5VLOptionalArgsT = H5VLOptionalArgsT

    enum :H5VL_attr_get_t, [
      :H5VL_ATTR_GET_ACPL, 0,
      :H5VL_ATTR_GET_INFO, 1,
      :H5VL_ATTR_GET_NAME, 2,
      :H5VL_ATTR_GET_SPACE, 3,
      :H5VL_ATTR_GET_STORAGE_SIZE, 4,
      :H5VL_ATTR_GET_TYPE, 5
    ]

    typedef :H5VL_attr_get_t, :H5VL_attr_get_t

    class H5VLAttrGetNameArgsT < ::FFI::Struct
      layout \
        :loc_params, H5VLLocParamsT,
        :buf_size, :size_t,
        :buf, :string,
        :attr_name_len, :pointer
    end

    # H5VLAttrGetNameArgsT = H5VLAttrGetNameArgsT

    class H5VLAttrGetInfoArgsT < ::FFI::Struct
      layout \
        :loc_params, H5VLLocParamsT,
        :attr_name, :string,
        :ainfo, H5AInfoT.ptr
    end

    # H5VLAttrGetInfoArgsT = H5VLAttrGetInfoArgsT

    class Anon_Type_39 < ::FFI::Struct
      layout \
        :acpl_id, :hid_t
    end

    class Anon_Type_40 < ::FFI::Struct
      layout \
        :space_id, :hid_t
    end

    class Anon_Type_41 < ::FFI::Struct
      layout \
        :data_size, :pointer
    end

    class Anon_Type_42 < ::FFI::Struct
      layout \
        :type_id, :hid_t
    end

    class Anon_Type_38 < ::FFI::Union
      layout \
        :get_acpl, Anon_Type_39,
        :get_info, H5VLAttrGetInfoArgsT,
        :get_name, H5VLAttrGetNameArgsT,
        :get_space, Anon_Type_40,
        :get_storage_size, Anon_Type_41,
        :get_type, Anon_Type_42
    end

    class H5VLAttrGetArgsT < ::FFI::Struct
      layout \
        :op_type, :H5VL_attr_get_t,
        :args, Anon_Type_38
    end

    # H5VLAttrGetArgsT = H5VLAttrGetArgsT

    enum :H5VL_attr_specific_t, [
      :H5VL_ATTR_DELETE, 0,
      :H5VL_ATTR_DELETE_BY_IDX, 1,
      :H5VL_ATTR_EXISTS, 2,
      :H5VL_ATTR_ITER, 3,
      :H5VL_ATTR_RENAME, 4
    ]

    typedef :H5VL_attr_specific_t, :H5VL_attr_specific_t

    class H5VLAttrIterateArgsT < ::FFI::Struct
      layout \
        :idx_type, :H5_index_t,
        :order, :H5_iter_order_t,
        :idx, :pointer,
        :op, :H5A_operator2_t,
        :op_data, :pointer
    end

    # H5VLAttrIterateArgsT = H5VLAttrIterateArgsT

    class H5VLAttrDeleteByIdxArgsT < ::FFI::Struct
      layout \
        :idx_type, :H5_index_t,
        :order, :H5_iter_order_t,
        :n, :hsize_t
    end

    # H5VLAttrDeleteByIdxArgsT = H5VLAttrDeleteByIdxArgsT

    class Anon_Type_44 < ::FFI::Struct
      layout \
        :name, :string
    end

    class Anon_Type_45 < ::FFI::Struct
      layout \
        :name, :string,
        :exists, :pointer
    end

    class Anon_Type_46 < ::FFI::Struct
      layout \
        :old_name, :string,
        :new_name, :string
    end

    class Anon_Type_43 < ::FFI::Union
      layout \
        :del, Anon_Type_44,
        :delete_by_idx, H5VLAttrDeleteByIdxArgsT,
        :exists, Anon_Type_45,
        :iterate, H5VLAttrIterateArgsT,
        :rename, Anon_Type_46
    end

    class H5VLAttrSpecificArgsT < ::FFI::Struct
      layout \
        :op_type, :H5VL_attr_specific_t,
        :args, Anon_Type_43
    end

    # H5VLAttrSpecificArgsT = H5VLAttrSpecificArgsT

    typedef :int, :H5VL_attr_optional_t

    enum :H5VL_dataset_get_t, [
      :H5VL_DATASET_GET_DAPL, 0,
      :H5VL_DATASET_GET_DCPL, 1,
      :H5VL_DATASET_GET_SPACE, 2,
      :H5VL_DATASET_GET_SPACE_STATUS, 3,
      :H5VL_DATASET_GET_STORAGE_SIZE, 4,
      :H5VL_DATASET_GET_TYPE, 5
    ]

    typedef :H5VL_dataset_get_t, :H5VL_dataset_get_t

    class Anon_Type_48 < ::FFI::Struct
      layout \
        :dapl_id, :hid_t
    end

    class Anon_Type_49 < ::FFI::Struct
      layout \
        :dcpl_id, :hid_t
    end

    class Anon_Type_50 < ::FFI::Struct
      layout \
        :space_id, :hid_t
    end

    class Anon_Type_51 < ::FFI::Struct
      layout \
        :status, :pointer
    end

    class Anon_Type_52 < ::FFI::Struct
      layout \
        :storage_size, :pointer
    end

    class Anon_Type_53 < ::FFI::Struct
      layout \
        :type_id, :hid_t
    end

    class Anon_Type_47 < ::FFI::Union
      layout \
        :get_dapl, Anon_Type_48,
        :get_dcpl, Anon_Type_49,
        :get_space, Anon_Type_50,
        :get_space_status, Anon_Type_51,
        :get_storage_size, Anon_Type_52,
        :get_type, Anon_Type_53
    end

    class H5VLDatasetGetArgsT < ::FFI::Struct
      layout \
        :op_type, :H5VL_dataset_get_t,
        :args, Anon_Type_47
    end

    # H5VLDatasetGetArgsT = H5VLDatasetGetArgsT

    enum :H5VL_dataset_specific_t, [
      :H5VL_DATASET_SET_EXTENT, 0,
      :H5VL_DATASET_FLUSH, 1,
      :H5VL_DATASET_REFRESH, 2
    ]

    typedef :H5VL_dataset_specific_t, :H5VL_dataset_specific_t

    class Anon_Type_55 < ::FFI::Struct
      layout \
        :size, :pointer
    end

    class Anon_Type_56 < ::FFI::Struct
      layout \
        :dset_id, :hid_t
    end

    class Anon_Type_57 < ::FFI::Struct
      layout \
        :dset_id, :hid_t
    end

    class Anon_Type_54 < ::FFI::Union
      layout \
        :set_extent, Anon_Type_55,
        :flush, Anon_Type_56,
        :refresh, Anon_Type_57
    end

    class H5VLDatasetSpecificArgsT < ::FFI::Struct
      layout \
        :op_type, :H5VL_dataset_specific_t,
        :args, Anon_Type_54
    end

    # H5VLDatasetSpecificArgsT = H5VLDatasetSpecificArgsT

    typedef :int, :H5VL_dataset_optional_t

    enum :H5VL_datatype_get_t, [
      :H5VL_DATATYPE_GET_BINARY_SIZE, 0,
      :H5VL_DATATYPE_GET_BINARY, 1,
      :H5VL_DATATYPE_GET_TCPL, 2
    ]

    typedef :H5VL_datatype_get_t, :H5VL_datatype_get_t

    class Anon_Type_59 < ::FFI::Struct
      layout \
        :size, :pointer
    end

    class Anon_Type_60 < ::FFI::Struct
      layout \
        :buf, :pointer,
        :buf_size, :size_t
    end

    class Anon_Type_61 < ::FFI::Struct
      layout \
        :tcpl_id, :hid_t
    end

    class Anon_Type_58 < ::FFI::Union
      layout \
        :get_binary_size, Anon_Type_59,
        :get_binary, Anon_Type_60,
        :get_tcpl, Anon_Type_61
    end

    class H5VLDatatypeGetArgsT < ::FFI::Struct
      layout \
        :op_type, :H5VL_datatype_get_t,
        :args, Anon_Type_58
    end

    # H5VLDatatypeGetArgsT = H5VLDatatypeGetArgsT

    enum :H5VL_datatype_specific_t, [
      :H5VL_DATATYPE_FLUSH, 0,
      :H5VL_DATATYPE_REFRESH, 1
    ]

    typedef :H5VL_datatype_specific_t, :H5VL_datatype_specific_t

    class Anon_Type_63 < ::FFI::Struct
      layout \
        :type_id, :hid_t
    end

    class Anon_Type_64 < ::FFI::Struct
      layout \
        :type_id, :hid_t
    end

    class Anon_Type_62 < ::FFI::Union
      layout \
        :flush, Anon_Type_63,
        :refresh, Anon_Type_64
    end

    class H5VLDatatypeSpecificArgsT < ::FFI::Struct
      layout \
        :op_type, :H5VL_datatype_specific_t,
        :args, Anon_Type_62
    end

    # H5VLDatatypeSpecificArgsT = H5VLDatatypeSpecificArgsT

    typedef :int, :H5VL_datatype_optional_t

    class H5VLFileContInfoT < ::FFI::Struct
      layout \
        :version, :uint,
        :feature_flags, :uint64_t,
        :token_size, :size_t,
        :blob_id_size, :size_t
    end

    # H5VLFileContInfoT = H5VLFileContInfoT

    enum :H5VL_file_get_t, [
      :H5VL_FILE_GET_CONT_INFO, 0,
      :H5VL_FILE_GET_FAPL, 1,
      :H5VL_FILE_GET_FCPL, 2,
      :H5VL_FILE_GET_FILENO, 3,
      :H5VL_FILE_GET_INTENT, 4,
      :H5VL_FILE_GET_NAME, 5,
      :H5VL_FILE_GET_OBJ_COUNT, 6,
      :H5VL_FILE_GET_OBJ_IDS, 7
    ]

    typedef :H5VL_file_get_t, :H5VL_file_get_t

    class H5VLFileGetNameArgsT < ::FFI::Struct
      layout \
        :type, :H5I_type_t,
        :buf_size, :size_t,
        :buf, :string,
        :file_name_len, :pointer
    end

    # H5VLFileGetNameArgsT = H5VLFileGetNameArgsT

    class H5VLFileGetObjIdsArgsT < ::FFI::Struct
      layout \
        :types, :uint,
        :max_objs, :size_t,
        :oid_list, :pointer,
        :count, :pointer
    end

    # H5VLFileGetObjIdsArgsT = H5VLFileGetObjIdsArgsT

    class Anon_Type_66 < ::FFI::Struct
      layout \
        :info, H5VLFileContInfoT.ptr
    end

    class Anon_Type_67 < ::FFI::Struct
      layout \
        :fapl_id, :hid_t
    end

    class Anon_Type_68 < ::FFI::Struct
      layout \
        :fcpl_id, :hid_t
    end

    class Anon_Type_69 < ::FFI::Struct
      layout \
        :fileno, :pointer
    end

    class Anon_Type_70 < ::FFI::Struct
      layout \
        :flags, :pointer
    end

    class Anon_Type_71 < ::FFI::Struct
      layout \
        :types, :uint,
        :count, :pointer
    end

    class Anon_Type_65 < ::FFI::Union
      layout \
        :get_cont_info, Anon_Type_66,
        :get_fapl, Anon_Type_67,
        :get_fcpl, Anon_Type_68,
        :get_fileno, Anon_Type_69,
        :get_intent, Anon_Type_70,
        :get_name, H5VLFileGetNameArgsT,
        :get_obj_count, Anon_Type_71,
        :get_obj_ids, H5VLFileGetObjIdsArgsT
    end

    class H5VLFileGetArgsT < ::FFI::Struct
      layout \
        :op_type, :H5VL_file_get_t,
        :args, Anon_Type_65
    end

    # H5VLFileGetArgsT = H5VLFileGetArgsT

    enum :H5VL_file_specific_t, [
      :H5VL_FILE_FLUSH, 0,
      :H5VL_FILE_REOPEN, 1,
      :H5VL_FILE_IS_ACCESSIBLE, 2,
      :H5VL_FILE_DELETE, 3,
      :H5VL_FILE_IS_EQUAL, 4
    ]

    typedef :H5VL_file_specific_t, :H5VL_file_specific_t

    class Anon_Type_73 < ::FFI::Struct
      layout \
        :obj_type, :H5I_type_t,
        :scope, :H5F_scope_t
    end

    class Anon_Type_74 < ::FFI::Struct
      layout \
        :file, :pointer
    end

    class Anon_Type_75 < ::FFI::Struct
      layout \
        :filename, :string,
        :fapl_id, :hid_t,
        :accessible, :pointer
    end

    class Anon_Type_76 < ::FFI::Struct
      layout \
        :filename, :string,
        :fapl_id, :hid_t
    end

    class Anon_Type_77 < ::FFI::Struct
      layout \
        :obj2, :pointer,
        :same_file, :pointer
    end

    class Anon_Type_72 < ::FFI::Union
      layout \
        :flush, Anon_Type_73,
        :reopen, Anon_Type_74,
        :is_accessible, Anon_Type_75,
        :del, Anon_Type_76,
        :is_equal, Anon_Type_77
    end

    class H5VLFileSpecificArgsT < ::FFI::Struct
      layout \
        :op_type, :H5VL_file_specific_t,
        :args, Anon_Type_72
    end

    # H5VLFileSpecificArgsT = H5VLFileSpecificArgsT

    typedef :int, :H5VL_file_optional_t

    enum :H5VL_group_get_t, [
      :H5VL_GROUP_GET_GCPL, 0,
      :H5VL_GROUP_GET_INFO, 1
    ]

    typedef :H5VL_group_get_t, :H5VL_group_get_t

    class H5VLGroupGetInfoArgsT < ::FFI::Struct
      layout \
        :loc_params, H5VLLocParamsT,
        :ginfo, H5GInfoT.ptr
    end

    # H5VLGroupGetInfoArgsT = H5VLGroupGetInfoArgsT

    class Anon_Type_79 < ::FFI::Struct
      layout \
        :gcpl_id, :hid_t
    end

    class Anon_Type_78 < ::FFI::Union
      layout \
        :get_gcpl, Anon_Type_79,
        :get_info, H5VLGroupGetInfoArgsT
    end

    class H5VLGroupGetArgsT < ::FFI::Struct
      layout \
        :op_type, :H5VL_group_get_t,
        :args, Anon_Type_78
    end

    # H5VLGroupGetArgsT = H5VLGroupGetArgsT

    enum :H5VL_group_specific_t, [
      :H5VL_GROUP_MOUNT, 0,
      :H5VL_GROUP_UNMOUNT, 1,
      :H5VL_GROUP_FLUSH, 2,
      :H5VL_GROUP_REFRESH, 3
    ]

    typedef :H5VL_group_specific_t, :H5VL_group_specific_t

    class H5VLGroupSpecMountArgsT < ::FFI::Struct
      layout \
        :name, :string,
        :child_file, :pointer,
        :fmpl_id, :hid_t
    end

    # H5VLGroupSpecMountArgsT = H5VLGroupSpecMountArgsT

    class Anon_Type_81 < ::FFI::Struct
      layout \
        :name, :string
    end

    class Anon_Type_82 < ::FFI::Struct
      layout \
        :grp_id, :hid_t
    end

    class Anon_Type_83 < ::FFI::Struct
      layout \
        :grp_id, :hid_t
    end

    class Anon_Type_80 < ::FFI::Union
      layout \
        :mount, H5VLGroupSpecMountArgsT,
        :unmount, Anon_Type_81,
        :flush, Anon_Type_82,
        :refresh, Anon_Type_83
    end

    class H5VLGroupSpecificArgsT < ::FFI::Struct
      layout \
        :op_type, :H5VL_group_specific_t,
        :args, Anon_Type_80
    end

    # H5VLGroupSpecificArgsT = H5VLGroupSpecificArgsT

    typedef :int, :H5VL_group_optional_t

    enum :H5VL_link_create_t, [
      :H5VL_LINK_CREATE_HARD, 0,
      :H5VL_LINK_CREATE_SOFT, 1,
      :H5VL_LINK_CREATE_UD, 2
    ]

    typedef :H5VL_link_create_t, :H5VL_link_create_t

    class Anon_Type_85 < ::FFI::Struct
      layout \
        :curr_obj, :pointer,
        :curr_loc_params, H5VLLocParamsT
    end

    class Anon_Type_86 < ::FFI::Struct
      layout \
        :target, :string
    end

    class Anon_Type_87 < ::FFI::Struct
      layout \
        :type, :H5L_type_t,
        :buf, :pointer,
        :buf_size, :size_t
    end

    class Anon_Type_84 < ::FFI::Union
      layout \
        :hard, Anon_Type_85,
        :soft, Anon_Type_86,
        :ud, Anon_Type_87
    end

    class H5VLLinkCreateArgsT < ::FFI::Struct
      layout \
        :op_type, :H5VL_link_create_t,
        :args, Anon_Type_84
    end

    # H5VLLinkCreateArgsT = H5VLLinkCreateArgsT

    enum :H5VL_link_get_t, [
      :H5VL_LINK_GET_INFO, 0,
      :H5VL_LINK_GET_NAME, 1,
      :H5VL_LINK_GET_VAL, 2
    ]

    typedef :H5VL_link_get_t, :H5VL_link_get_t

    class Anon_Type_89 < ::FFI::Struct
      layout \
        :linfo, H5LInfo2T.ptr
    end

    class Anon_Type_90 < ::FFI::Struct
      layout \
        :name_size, :size_t,
        :name, :string,
        :name_len, :pointer
    end

    class Anon_Type_91 < ::FFI::Struct
      layout \
        :buf_size, :size_t,
        :buf, :pointer
    end

    class Anon_Type_88 < ::FFI::Union
      layout \
        :get_info, Anon_Type_89,
        :get_name, Anon_Type_90,
        :get_val, Anon_Type_91
    end

    class H5VLLinkGetArgsT < ::FFI::Struct
      layout \
        :op_type, :H5VL_link_get_t,
        :args, Anon_Type_88
    end

    # H5VLLinkGetArgsT = H5VLLinkGetArgsT

    enum :H5VL_link_specific_t, [
      :H5VL_LINK_DELETE, 0,
      :H5VL_LINK_EXISTS, 1,
      :H5VL_LINK_ITER, 2
    ]

    typedef :H5VL_link_specific_t, :H5VL_link_specific_t

    class H5VLLinkIterateArgsT < ::FFI::Struct
      layout \
        :recursive, :hbool_t,
        :idx_type, :H5_index_t,
        :order, :H5_iter_order_t,
        :idx_p, :pointer,
        :op, :H5L_iterate2_t,
        :op_data, :pointer
    end

    # H5VLLinkIterateArgsT = H5VLLinkIterateArgsT

    class Anon_Type_93 < ::FFI::Struct
      layout \
        :exists, :pointer
    end

    class Anon_Type_92 < ::FFI::Union
      layout \
        :exists, Anon_Type_93,
        :iterate, H5VLLinkIterateArgsT
    end

    class H5VLLinkSpecificArgsT < ::FFI::Struct
      layout \
        :op_type, :H5VL_link_specific_t,
        :args, Anon_Type_92
    end

    # H5VLLinkSpecificArgsT = H5VLLinkSpecificArgsT

    typedef :int, :H5VL_link_optional_t

    enum :H5VL_object_get_t, [
      :H5VL_OBJECT_GET_FILE, 0,
      :H5VL_OBJECT_GET_NAME, 1,
      :H5VL_OBJECT_GET_TYPE, 2,
      :H5VL_OBJECT_GET_INFO, 3
    ]

    typedef :H5VL_object_get_t, :H5VL_object_get_t

    class Anon_Type_95 < ::FFI::Struct
      layout \
        :file, :pointer
    end

    class Anon_Type_96 < ::FFI::Struct
      layout \
        :buf_size, :size_t,
        :buf, :string,
        :name_len, :pointer
    end

    class Anon_Type_97 < ::FFI::Struct
      layout \
        :obj_type, :pointer
    end

    class Anon_Type_98 < ::FFI::Struct
      layout \
        :fields, :uint,
        :oinfo, H5OInfo2T.ptr
    end

    class Anon_Type_94 < ::FFI::Union
      layout \
        :get_file, Anon_Type_95,
        :get_name, Anon_Type_96,
        :get_type, Anon_Type_97,
        :get_info, Anon_Type_98
    end

    class H5VLObjectGetArgsT < ::FFI::Struct
      layout \
        :op_type, :H5VL_object_get_t,
        :args, Anon_Type_94
    end

    # H5VLObjectGetArgsT = H5VLObjectGetArgsT

    enum :H5VL_object_specific_t, [
      :H5VL_OBJECT_CHANGE_REF_COUNT, 0,
      :H5VL_OBJECT_EXISTS, 1,
      :H5VL_OBJECT_LOOKUP, 2,
      :H5VL_OBJECT_VISIT, 3,
      :H5VL_OBJECT_FLUSH, 4,
      :H5VL_OBJECT_REFRESH, 5
    ]

    typedef :H5VL_object_specific_t, :H5VL_object_specific_t

    class H5VLObjectVisitArgsT < ::FFI::Struct
      layout \
        :idx_type, :H5_index_t,
        :order, :H5_iter_order_t,
        :fields, :uint,
        :op, :H5O_iterate2_t,
        :op_data, :pointer
    end

    # H5VLObjectVisitArgsT = H5VLObjectVisitArgsT

    class Anon_Type_100 < ::FFI::Struct
      layout \
        :delta, :int
    end

    class Anon_Type_101 < ::FFI::Struct
      layout \
        :exists, :pointer
    end

    class Anon_Type_102 < ::FFI::Struct
      layout \
        :token_ptr, H5OTokenT.ptr
    end

    class Anon_Type_103 < ::FFI::Struct
      layout \
        :obj_id, :hid_t
    end

    class Anon_Type_104 < ::FFI::Struct
      layout \
        :obj_id, :hid_t
    end

    class Anon_Type_99 < ::FFI::Union
      layout \
        :change_rc, Anon_Type_100,
        :exists, Anon_Type_101,
        :lookup, Anon_Type_102,
        :visit, H5VLObjectVisitArgsT,
        :flush, Anon_Type_103,
        :refresh, Anon_Type_104
    end

    class H5VLObjectSpecificArgsT < ::FFI::Struct
      layout \
        :op_type, :H5VL_object_specific_t,
        :args, Anon_Type_99
    end

    # H5VLObjectSpecificArgsT = H5VLObjectSpecificArgsT

    typedef :int, :H5VL_object_optional_t

    enum :H5VL_request_status_t, [
      :H5VL_REQUEST_STATUS_IN_PROGRESS, 0,
      :H5VL_REQUEST_STATUS_SUCCEED, 1,
      :H5VL_REQUEST_STATUS_FAIL, 2,
      :H5VL_REQUEST_STATUS_CANT_CANCEL, 3,
      :H5VL_REQUEST_STATUS_CANCELED, 4
    ]

    typedef :H5VL_request_status_t, :H5VL_request_status_t

    enum :H5VL_request_specific_t, [
      :H5VL_REQUEST_GET_ERR_STACK, 0,
      :H5VL_REQUEST_GET_EXEC_TIME, 1
    ]

    typedef :H5VL_request_specific_t, :H5VL_request_specific_t

    class Anon_Type_106 < ::FFI::Struct
      layout \
        :err_stack_id, :hid_t
    end

    class Anon_Type_107 < ::FFI::Struct
      layout \
        :exec_ts, :pointer,
        :exec_time, :pointer
    end

    class Anon_Type_105 < ::FFI::Union
      layout \
        :get_err_stack, Anon_Type_106,
        :get_exec_time, Anon_Type_107
    end

    class H5VLRequestSpecificArgsT < ::FFI::Struct
      layout \
        :op_type, :H5VL_request_specific_t,
        :args, Anon_Type_105
    end

    # H5VLRequestSpecificArgsT = H5VLRequestSpecificArgsT

    typedef :int, :H5VL_request_optional_t

    enum :H5VL_blob_specific_t, [
      :H5VL_BLOB_DELETE, 0,
      :H5VL_BLOB_ISNULL, 1,
      :H5VL_BLOB_SETNULL, 2
    ]

    typedef :H5VL_blob_specific_t, :H5VL_blob_specific_t

    class Anon_Type_109 < ::FFI::Struct
      layout \
        :isnull, :pointer
    end

    class Anon_Type_108 < ::FFI::Union
      layout \
        :is_null, Anon_Type_109
    end

    class H5VLBlobSpecificArgsT < ::FFI::Struct
      layout \
        :op_type, :H5VL_blob_specific_t,
        :args, Anon_Type_108
    end

    # H5VLBlobSpecificArgsT = H5VLBlobSpecificArgsT

    typedef :int, :H5VL_blob_optional_t

    class H5VLInfoClassT < ::FFI::Struct
      layout \
        :size, :size_t,
        :copy, :pointer,
        :cmp, :pointer,
        :free, :pointer,
        :to_str, :pointer,
        :from_str, :pointer
    end

    # H5VLInfoClassT = H5VLInfoClassT

    class H5VLWrapClassT < ::FFI::Struct
      layout \
        :get_object, :pointer,
        :get_wrap_ctx, :pointer,
        :wrap_object, :pointer,
        :unwrap_object, :pointer,
        :free_wrap_ctx, :pointer
    end

    # H5VLWrapClassT = H5VLWrapClassT

    class H5VLAttrClassT < ::FFI::Struct
      layout \
        :create, :pointer,
        :open, :pointer,
        :read, :pointer,
        :write, :pointer,
        :get, :pointer,
        :specific, :pointer,
        :optional, :pointer,
        :close, :pointer
    end

    # H5VLAttrClassT = H5VLAttrClassT

    class H5VLDatasetClassT < ::FFI::Struct
      layout \
        :create, :pointer,
        :open, :pointer,
        :read, :pointer,
        :write, :pointer,
        :get, :pointer,
        :specific, :pointer,
        :optional, :pointer,
        :close, :pointer
    end

    # H5VLDatasetClassT = H5VLDatasetClassT

    class H5VLDatatypeClassT < ::FFI::Struct
      layout \
        :commit, :pointer,
        :open, :pointer,
        :get, :pointer,
        :specific, :pointer,
        :optional, :pointer,
        :close, :pointer
    end

    # H5VLDatatypeClassT = H5VLDatatypeClassT

    class H5VLFileClassT < ::FFI::Struct
      layout \
        :create, :pointer,
        :open, :pointer,
        :get, :pointer,
        :specific, :pointer,
        :optional, :pointer,
        :close, :pointer
    end

    # H5VLFileClassT = H5VLFileClassT

    class H5VLGroupClassT < ::FFI::Struct
      layout \
        :create, :pointer,
        :open, :pointer,
        :get, :pointer,
        :specific, :pointer,
        :optional, :pointer,
        :close, :pointer
    end

    # H5VLGroupClassT = H5VLGroupClassT

    class H5VLLinkClassT < ::FFI::Struct
      layout \
        :create, :pointer,
        :copy, :pointer,
        :move, :pointer,
        :get, :pointer,
        :specific, :pointer,
        :optional, :pointer
    end

    # H5VLLinkClassT = H5VLLinkClassT

    class H5VLObjectClassT < ::FFI::Struct
      layout \
        :open, :pointer,
        :copy, :pointer,
        :get, :pointer,
        :specific, :pointer,
        :optional, :pointer
    end

    # H5VLObjectClassT = H5VLObjectClassT

    typedef :pointer, :H5VL_request_notify_t

    enum :H5VL_get_conn_lvl_t, [
      :H5VL_GET_CONN_LVL_CURR, 0,
      :H5VL_GET_CONN_LVL_TERM, 1
    ]

    typedef :H5VL_get_conn_lvl_t, :H5VL_get_conn_lvl_t

    class H5VLClassT < ::FFI::Struct
    end

    class H5VLIntrospectClassT < ::FFI::Struct
      layout \
        :get_conn_cls, :pointer,
        :get_cap_flags, :pointer,
        :opt_query, :pointer
    end

    # H5VLIntrospectClassT = H5VLIntrospectClassT

    class H5VLRequestClassT < ::FFI::Struct
      layout \
        :wait, :pointer,
        :notify, :pointer,
        :cancel, :pointer,
        :specific, :pointer,
        :optional, :pointer,
        :free, :pointer
    end

    # H5VLRequestClassT = H5VLRequestClassT

    class H5VLBlobClassT < ::FFI::Struct
      layout \
        :put, :pointer,
        :get, :pointer,
        :specific, :pointer,
        :optional, :pointer
    end

    # H5VLBlobClassT = H5VLBlobClassT

    class H5VLTokenClassT < ::FFI::Struct
      layout \
        :cmp, :pointer,
        :to_str, :pointer,
        :from_str, :pointer
    end

    # H5VLTokenClassT = H5VLTokenClassT

    # Already defined? H5VLClassT

    # H5VLClassT = H5VLClassT

    attach_function 'H5VLregister_connector', [
      H5VLClassT.ptr,
      :hid_t
    ], :hid_t

    attach_function 'H5VLobject', [
      :hid_t
    ], :pointer

    attach_function 'H5VLget_file_type', %i[
      pointer
      hid_t
      hid_t
    ], :hid_t

    attach_function 'H5VLpeek_connector_id_by_name', [
      :string
    ], :hid_t

    attach_function 'H5VLpeek_connector_id_by_value', [
      :H5VL_class_value_t
    ], :hid_t

    attach_function 'H5VLregister_opt_operation', %i[
      H5VL_subclass_t
      string
      pointer
    ], :herr_t

    attach_function 'H5VLfind_opt_operation', %i[
      H5VL_subclass_t
      string
      pointer
    ], :herr_t

    attach_function 'H5VLunregister_opt_operation', %i[
      H5VL_subclass_t
      string
    ], :herr_t

    attach_function 'H5VLattr_optional_op', [
      :string,
      :string,
      :uint,
      :hid_t,
      H5VLOptionalArgsT.ptr,
      :hid_t,
      :hid_t
    ], :herr_t

    attach_function 'H5VLdataset_optional_op', [
      :string,
      :string,
      :uint,
      :hid_t,
      H5VLOptionalArgsT.ptr,
      :hid_t,
      :hid_t
    ], :herr_t

    attach_function 'H5VLdatatype_optional_op', [
      :string,
      :string,
      :uint,
      :hid_t,
      H5VLOptionalArgsT.ptr,
      :hid_t,
      :hid_t
    ], :herr_t

    attach_function 'H5VLfile_optional_op', [
      :string,
      :string,
      :uint,
      :hid_t,
      H5VLOptionalArgsT.ptr,
      :hid_t,
      :hid_t
    ], :herr_t

    attach_function 'H5VLgroup_optional_op', [
      :string,
      :string,
      :uint,
      :hid_t,
      H5VLOptionalArgsT.ptr,
      :hid_t,
      :hid_t
    ], :herr_t

    attach_function 'H5VLlink_optional_op', [
      :string,
      :string,
      :uint,
      :hid_t,
      :string,
      :hid_t,
      H5VLOptionalArgsT.ptr,
      :hid_t,
      :hid_t
    ], :herr_t

    attach_function 'H5VLobject_optional_op', [
      :string,
      :string,
      :uint,
      :hid_t,
      :string,
      :hid_t,
      H5VLOptionalArgsT.ptr,
      :hid_t,
      :hid_t
    ], :herr_t

    attach_function 'H5VLrequest_optional_op', [
      :pointer,
      :hid_t,
      H5VLOptionalArgsT.ptr
    ], :herr_t

    enum :H5VL_map_get_t, [
      :H5VL_MAP_GET_MAPL, 0,
      :H5VL_MAP_GET_MCPL, 1,
      :H5VL_MAP_GET_KEY_TYPE, 2,
      :H5VL_MAP_GET_VAL_TYPE, 3,
      :H5VL_MAP_GET_COUNT, 4
    ]

    typedef :H5VL_map_get_t, :H5VL_map_get_t

    enum :H5VL_map_specific_t, [
      :H5VL_MAP_ITER, 0,
      :H5VL_MAP_DELETE, 1
    ]

    typedef :H5VL_map_specific_t, :H5VL_map_specific_t

    typedef :pointer, :H5M_iterate_t

    class Anon_Type_110 < ::FFI::Struct
      layout \
        :loc_params, H5VLLocParamsT,
        :name, :string,
        :lcpl_id, :hid_t,
        :key_type_id, :hid_t,
        :val_type_id, :hid_t,
        :mcpl_id, :hid_t,
        :mapl_id, :hid_t,
        :map, :pointer
    end

    class Anon_Type_111 < ::FFI::Struct
      layout \
        :loc_params, H5VLLocParamsT,
        :name, :string,
        :mapl_id, :hid_t,
        :map, :pointer
    end

    class Anon_Type_112 < ::FFI::Struct
      layout \
        :key_mem_type_id, :hid_t,
        :key, :pointer,
        :value_mem_type_id, :hid_t,
        :value, :pointer
    end

    class Anon_Type_113 < ::FFI::Struct
      layout \
        :key_mem_type_id, :hid_t,
        :key, :pointer,
        :exists, :hbool_t
    end

    class Anon_Type_114 < ::FFI::Struct
      layout \
        :key_mem_type_id, :hid_t,
        :key, :pointer,
        :value_mem_type_id, :hid_t,
        :value, :pointer
    end

    class Anon_Type_117 < ::FFI::Struct
      layout \
        :mapl_id, :hid_t
    end

    class Anon_Type_118 < ::FFI::Struct
      layout \
        :mcpl_id, :hid_t
    end

    class Anon_Type_119 < ::FFI::Struct
      layout \
        :type_id, :hid_t
    end

    class Anon_Type_120 < ::FFI::Struct
      layout \
        :type_id, :hid_t
    end

    class Anon_Type_121 < ::FFI::Struct
      layout \
        :count, :hsize_t
    end

    class Anon_Type_116 < ::FFI::Union
      layout \
        :get_mapl, Anon_Type_117,
        :get_mcpl, Anon_Type_118,
        :get_key_type, Anon_Type_119,
        :get_val_type, Anon_Type_120,
        :get_count, Anon_Type_121
    end

    class Anon_Type_115 < ::FFI::Struct
      layout \
        :get_type, :H5VL_map_get_t,
        :args, Anon_Type_116
    end

    class Anon_Type_124 < ::FFI::Struct
      layout \
        :loc_params, H5VLLocParamsT,
        :idx, :hsize_t,
        :key_mem_type_id, :hid_t,
        :op, :H5M_iterate_t,
        :op_data, :pointer
    end

    class Anon_Type_125 < ::FFI::Struct
      layout \
        :loc_params, H5VLLocParamsT,
        :key_mem_type_id, :hid_t,
        :key, :pointer
    end

    class Anon_Type_123 < ::FFI::Union
      layout \
        :iterate, Anon_Type_124,
        :del, Anon_Type_125
    end

    class Anon_Type_122 < ::FFI::Struct
      layout \
        :specific_type, :H5VL_map_specific_t,
        :args, Anon_Type_123
    end

    class H5VLMapArgsT < ::FFI::Union
      layout \
        :create, Anon_Type_110,
        :open, Anon_Type_111,
        :get_val, Anon_Type_112,
        :exists, Anon_Type_113,
        :put, Anon_Type_114,
        :get, Anon_Type_115,
        :specific, Anon_Type_122
    end

    # H5VLMapArgsT = H5VLMapArgsT

    typedef :pointer, :H5MM_allocate_t

    typedef :pointer, :H5MM_free_t

    enum :H5S_class_t, [
      :H5S_NO_CLASS, 4_294_967_295,
      :H5S_SCALAR, 0,
      :H5S_SIMPLE, 1,
      :H5S_NULL, 2
    ]

    typedef :H5S_class_t, :H5S_class_t

    enum :H5S_seloper_t, [
      :H5S_SELECT_NOOP, 4_294_967_295,
      :H5S_SELECT_SET, 0,
      :H5S_SELECT_OR, 1,
      :H5S_SELECT_AND, 2,
      :H5S_SELECT_XOR, 3,
      :H5S_SELECT_NOTB, 4,
      :H5S_SELECT_NOTA, 5,
      :H5S_SELECT_APPEND, 6,
      :H5S_SELECT_PREPEND, 7,
      :H5S_SELECT_INVALID, 8
    ]

    typedef :H5S_seloper_t, :H5S_seloper_t

    enum :anon_enum_214, [
      :H5S_SEL_ERROR, 4_294_967_295,
      :H5S_SEL_NONE, 0,
      :H5S_SEL_POINTS, 1,
      :H5S_SEL_HYPERSLABS, 2,
      :H5S_SEL_ALL, 3,
      :H5S_SEL_N, 4
    ]

    typedef :anon_enum_214, :H5S_sel_type

    attach_function 'H5Sclose', [
      :hid_t
    ], :herr_t

    attach_function 'H5Scombine_hyperslab', %i[
      hid_t
      H5S_seloper_t
      pointer
      pointer
      pointer
      pointer
    ], :hid_t

    attach_function 'H5Scombine_select', %i[
      hid_t
      H5S_seloper_t
      hid_t
    ], :hid_t

    attach_function 'H5Scopy', [
      :hid_t
    ], :hid_t

    attach_function 'H5Screate', [
      :H5S_class_t
    ], :hid_t

    attach_function 'H5Screate_simple', %i[
      int
      pointer
      pointer
    ], :hid_t

    attach_function 'H5Sdecode', [
      :pointer
    ], :hid_t

    attach_function 'H5Sencode2', %i[
      hid_t
      pointer
      pointer
      hid_t
    ], :herr_t

    attach_function 'H5Sextent_copy', %i[
      hid_t
      hid_t
    ], :herr_t

    attach_function 'H5Sextent_equal', %i[
      hid_t
      hid_t
    ], :htri_t

    attach_function 'H5Sget_regular_hyperslab', %i[
      hid_t
      pointer
      pointer
      pointer
      pointer
    ], :htri_t

    attach_function 'H5Sget_select_bounds', %i[
      hid_t
      pointer
      pointer
    ], :herr_t

    attach_function 'H5Sget_select_elem_npoints', [
      :hid_t
    ], :hssize_t

    attach_function 'H5Sget_select_elem_pointlist', %i[
      hid_t
      hsize_t
      hsize_t
      pointer
    ], :herr_t

    attach_function 'H5Sget_select_hyper_blocklist', %i[
      hid_t
      hsize_t
      hsize_t
      pointer
    ], :herr_t

    attach_function 'H5Sget_select_hyper_nblocks', [
      :hid_t
    ], :hssize_t

    attach_function 'H5Sget_select_npoints', [
      :hid_t
    ], :hssize_t

    attach_function 'H5Sget_select_type', [
      :hid_t
    ], :H5S_sel_type

    attach_function 'H5Sget_simple_extent_dims', %i[
      hid_t
      pointer
      pointer
    ], :int

    attach_function 'H5Sget_simple_extent_ndims', [
      :hid_t
    ], :int

    attach_function 'H5Sget_simple_extent_npoints', [
      :hid_t
    ], :hssize_t

    attach_function 'H5Sget_simple_extent_type', [
      :hid_t
    ], :H5S_class_t

    attach_function 'H5Sis_regular_hyperslab', [
      :hid_t
    ], :htri_t

    attach_function 'H5Sis_simple', [
      :hid_t
    ], :htri_t

    attach_function 'H5Smodify_select', %i[
      hid_t
      H5S_seloper_t
      hid_t
    ], :herr_t

    attach_function 'H5Soffset_simple', %i[
      hid_t
      pointer
    ], :herr_t

    attach_function 'H5Ssel_iter_close', [
      :hid_t
    ], :herr_t

    attach_function 'H5Ssel_iter_create', %i[
      hid_t
      size_t
      uint
    ], :hid_t

    attach_function 'H5Ssel_iter_get_seq_list', %i[
      hid_t
      size_t
      size_t
      pointer
      pointer
      pointer
      pointer
    ], :herr_t

    attach_function 'H5Ssel_iter_reset', %i[
      hid_t
      hid_t
    ], :herr_t

    attach_function 'H5Sselect_adjust', %i[
      hid_t
      pointer
    ], :herr_t

    attach_function 'H5Sselect_all', [
      :hid_t
    ], :herr_t

    attach_function 'H5Sselect_copy', %i[
      hid_t
      hid_t
    ], :herr_t

    attach_function 'H5Sselect_elements', %i[
      hid_t
      H5S_seloper_t
      size_t
      pointer
    ], :herr_t

    attach_function 'H5Sselect_hyperslab', %i[
      hid_t
      H5S_seloper_t
      pointer
      pointer
      pointer
      pointer
    ], :herr_t

    attach_function 'H5Sselect_intersect_block', %i[
      hid_t
      pointer
      pointer
    ], :htri_t

    attach_function 'H5Sselect_none', [
      :hid_t
    ], :herr_t

    attach_function 'H5Sselect_project_intersection', %i[
      hid_t
      hid_t
      hid_t
    ], :hid_t

    attach_function 'H5Sselect_shape_same', %i[
      hid_t
      hid_t
    ], :htri_t

    attach_function 'H5Sselect_valid', [
      :hid_t
    ], :htri_t

    attach_function 'H5Sset_extent_none', [
      :hid_t
    ], :herr_t

    attach_function 'H5Sset_extent_simple', %i[
      hid_t
      int
      pointer
      pointer
    ], :herr_t

    attach_function 'H5Sencode1', %i[
      hid_t
      pointer
      pointer
    ], :herr_t

    typedef :int, :H5Z_filter_t

    enum :H5Z_SO_scale_type_t, [
      :H5Z_SO_FLOAT_DSCALE, 0,
      :H5Z_SO_FLOAT_ESCALE, 1,
      :H5Z_SO_INT, 2
    ]

    typedef :H5Z_SO_scale_type_t, :H5Z_SO_scale_type_t

    enum :H5Z_EDC_t, [
      :H5Z_ERROR_EDC, 4_294_967_295,
      :H5Z_DISABLE_EDC, 0,
      :H5Z_ENABLE_EDC, 1,
      :H5Z_NO_EDC, 2
    ]

    typedef :H5Z_EDC_t, :H5Z_EDC_t

    enum :H5Z_cb_return_t, [
      :H5Z_CB_ERROR, 4_294_967_295,
      :H5Z_CB_FAIL, 0,
      :H5Z_CB_CONT, 1,
      :H5Z_CB_NO, 2
    ]

    typedef :H5Z_cb_return_t, :H5Z_cb_return_t

    typedef :pointer, :H5Z_filter_func_t

    attach_function 'H5Zfilter_avail', [
      :H5Z_filter_t
    ], :htri_t

    attach_function 'H5Zget_filter_info', %i[
      H5Z_filter_t
      pointer
    ], :herr_t

    typedef :pointer, :H5P_cls_create_func_t

    typedef :pointer, :H5P_cls_copy_func_t

    typedef :pointer, :H5P_cls_close_func_t

    typedef :pointer, :H5P_prp_cb1_t

    typedef :pointer, :H5P_prp_cb2_t

    typedef :H5P_prp_cb1_t, :H5P_prp_create_func_t

    typedef :H5P_prp_cb2_t, :H5P_prp_set_func_t

    typedef :H5P_prp_cb2_t, :H5P_prp_get_func_t

    typedef :pointer, :H5P_prp_encode_func_t

    typedef :pointer, :H5P_prp_decode_func_t

    typedef :H5P_prp_cb2_t, :H5P_prp_delete_func_t

    typedef :H5P_prp_cb1_t, :H5P_prp_copy_func_t

    typedef :pointer, :H5P_prp_compare_func_t

    typedef :H5P_prp_cb1_t, :H5P_prp_close_func_t

    typedef :pointer, :H5P_iterate_t

    enum :H5D_mpio_actual_chunk_opt_mode_t, [
      :H5D_MPIO_NO_CHUNK_OPTIMIZATION, 0,
      :H5D_MPIO_LINK_CHUNK, 1,
      :H5D_MPIO_MULTI_CHUNK, 2
    ]

    typedef :H5D_mpio_actual_chunk_opt_mode_t, :H5D_mpio_actual_chunk_opt_mode_t

    enum :H5D_mpio_actual_io_mode_t, [
      :H5D_MPIO_NO_COLLECTIVE, 0,
      :H5D_MPIO_CHUNK_INDEPENDENT, 1,
      :H5D_MPIO_CHUNK_COLLECTIVE, 2,
      :H5D_MPIO_CHUNK_MIXED, 3,
      :H5D_MPIO_CONTIGUOUS_COLLECTIVE, 4
    ]

    typedef :H5D_mpio_actual_io_mode_t, :H5D_mpio_actual_io_mode_t

    enum :H5D_mpio_no_collective_cause_t, [
      :H5D_MPIO_COLLECTIVE, 0,
      :H5D_MPIO_SET_INDEPENDENT, 1,
      :H5D_MPIO_DATATYPE_CONVERSION, 2,
      :H5D_MPIO_DATA_TRANSFORMS, 4,
      :H5D_MPIO_MPI_OPT_TYPES_ENV_VAR_DISABLED, 8,
      :H5D_MPIO_NOT_SIMPLE_OR_SCALAR_DATASPACES, 16,
      :H5D_MPIO_NOT_CONTIGUOUS_OR_CHUNKED_DATASET, 32,
      :H5D_MPIO_PARALLEL_FILTERED_WRITES_DISABLED, 64,
      :H5D_MPIO_ERROR_WHILE_CHECKING_COLLECTIVE_POSSIBLE, 128,
      :H5D_MPIO_NO_SELECTION_IO, 256,
      :H5D_MPIO_NO_COLLECTIVE_MAX_CAUSE, 512
    ]

    typedef :H5D_mpio_no_collective_cause_t, :H5D_mpio_no_collective_cause_t

    enum :H5D_selection_io_mode_t, [
      :H5D_SELECTION_IO_MODE_DEFAULT, 0,
      :H5D_SELECTION_IO_MODE_OFF, 1,
      :H5D_SELECTION_IO_MODE_ON, 2
    ]

    typedef :H5D_selection_io_mode_t, :H5D_selection_io_mode_t

    attach_variable :H5P_CLS_ROOT_ID_g, :H5P_CLS_ROOT_ID_g, :hid_t

    attach_variable :H5P_CLS_OBJECT_CREATE_ID_g, :H5P_CLS_OBJECT_CREATE_ID_g, :hid_t

    attach_variable :H5P_CLS_FILE_CREATE_ID_g, :H5P_CLS_FILE_CREATE_ID_g, :hid_t

    attach_variable :H5P_CLS_FILE_ACCESS_ID_g, :H5P_CLS_FILE_ACCESS_ID_g, :hid_t

    attach_variable :H5P_CLS_DATASET_CREATE_ID_g, :H5P_CLS_DATASET_CREATE_ID_g, :hid_t

    attach_variable :H5P_CLS_DATASET_ACCESS_ID_g, :H5P_CLS_DATASET_ACCESS_ID_g, :hid_t

    attach_variable :H5P_CLS_DATASET_XFER_ID_g, :H5P_CLS_DATASET_XFER_ID_g, :hid_t

    attach_variable :H5P_CLS_FILE_MOUNT_ID_g, :H5P_CLS_FILE_MOUNT_ID_g, :hid_t

    attach_variable :H5P_CLS_GROUP_CREATE_ID_g, :H5P_CLS_GROUP_CREATE_ID_g, :hid_t

    attach_variable :H5P_CLS_GROUP_ACCESS_ID_g, :H5P_CLS_GROUP_ACCESS_ID_g, :hid_t

    attach_variable :H5P_CLS_DATATYPE_CREATE_ID_g, :H5P_CLS_DATATYPE_CREATE_ID_g, :hid_t

    attach_variable :H5P_CLS_DATATYPE_ACCESS_ID_g, :H5P_CLS_DATATYPE_ACCESS_ID_g, :hid_t

    attach_variable :H5P_CLS_MAP_CREATE_ID_g, :H5P_CLS_MAP_CREATE_ID_g, :hid_t

    attach_variable :H5P_CLS_MAP_ACCESS_ID_g, :H5P_CLS_MAP_ACCESS_ID_g, :hid_t

    attach_variable :H5P_CLS_STRING_CREATE_ID_g, :H5P_CLS_STRING_CREATE_ID_g, :hid_t

    attach_variable :H5P_CLS_ATTRIBUTE_CREATE_ID_g, :H5P_CLS_ATTRIBUTE_CREATE_ID_g, :hid_t

    attach_variable :H5P_CLS_ATTRIBUTE_ACCESS_ID_g, :H5P_CLS_ATTRIBUTE_ACCESS_ID_g, :hid_t

    attach_variable :H5P_CLS_OBJECT_COPY_ID_g, :H5P_CLS_OBJECT_COPY_ID_g, :hid_t

    attach_variable :H5P_CLS_LINK_CREATE_ID_g, :H5P_CLS_LINK_CREATE_ID_g, :hid_t

    attach_variable :H5P_CLS_LINK_ACCESS_ID_g, :H5P_CLS_LINK_ACCESS_ID_g, :hid_t

    attach_variable :H5P_CLS_VOL_INITIALIZE_ID_g, :H5P_CLS_VOL_INITIALIZE_ID_g, :hid_t

    attach_variable :H5P_CLS_REFERENCE_ACCESS_ID_g, :H5P_CLS_REFERENCE_ACCESS_ID_g, :hid_t

    attach_variable :H5P_LST_FILE_CREATE_ID_g, :H5P_LST_FILE_CREATE_ID_g, :hid_t

    attach_variable :H5P_LST_FILE_ACCESS_ID_g, :H5P_LST_FILE_ACCESS_ID_g, :hid_t

    attach_variable :H5P_LST_DATASET_CREATE_ID_g, :H5P_LST_DATASET_CREATE_ID_g, :hid_t

    attach_variable :H5P_LST_DATASET_ACCESS_ID_g, :H5P_LST_DATASET_ACCESS_ID_g, :hid_t

    attach_variable :H5P_LST_DATASET_XFER_ID_g, :H5P_LST_DATASET_XFER_ID_g, :hid_t

    attach_variable :H5P_LST_FILE_MOUNT_ID_g, :H5P_LST_FILE_MOUNT_ID_g, :hid_t

    attach_variable :H5P_LST_GROUP_CREATE_ID_g, :H5P_LST_GROUP_CREATE_ID_g, :hid_t

    attach_variable :H5P_LST_GROUP_ACCESS_ID_g, :H5P_LST_GROUP_ACCESS_ID_g, :hid_t

    attach_variable :H5P_LST_DATATYPE_CREATE_ID_g, :H5P_LST_DATATYPE_CREATE_ID_g, :hid_t

    attach_variable :H5P_LST_DATATYPE_ACCESS_ID_g, :H5P_LST_DATATYPE_ACCESS_ID_g, :hid_t

    attach_variable :H5P_LST_MAP_CREATE_ID_g, :H5P_LST_MAP_CREATE_ID_g, :hid_t

    attach_variable :H5P_LST_MAP_ACCESS_ID_g, :H5P_LST_MAP_ACCESS_ID_g, :hid_t

    attach_variable :H5P_LST_ATTRIBUTE_CREATE_ID_g, :H5P_LST_ATTRIBUTE_CREATE_ID_g, :hid_t

    attach_variable :H5P_LST_ATTRIBUTE_ACCESS_ID_g, :H5P_LST_ATTRIBUTE_ACCESS_ID_g, :hid_t

    attach_variable :H5P_LST_OBJECT_COPY_ID_g, :H5P_LST_OBJECT_COPY_ID_g, :hid_t

    attach_variable :H5P_LST_LINK_CREATE_ID_g, :H5P_LST_LINK_CREATE_ID_g, :hid_t

    attach_variable :H5P_LST_LINK_ACCESS_ID_g, :H5P_LST_LINK_ACCESS_ID_g, :hid_t

    attach_variable :H5P_LST_VOL_INITIALIZE_ID_g, :H5P_LST_VOL_INITIALIZE_ID_g, :hid_t

    attach_variable :H5P_LST_REFERENCE_ACCESS_ID_g, :H5P_LST_REFERENCE_ACCESS_ID_g, :hid_t

    attach_function 'H5Pclose', [
      :hid_t
    ], :herr_t

    attach_function 'H5Pclose_class', [
      :hid_t
    ], :herr_t

    attach_function 'H5Pcopy', [
      :hid_t
    ], :hid_t

    attach_function 'H5Pcopy_prop', %i[
      hid_t
      hid_t
      string
    ], :herr_t

    attach_function 'H5Pcreate', [
      :hid_t
    ], :hid_t

    attach_function 'H5Pcreate_class', %i[
      hid_t
      string
      H5P_cls_create_func_t
      pointer
      H5P_cls_copy_func_t
      pointer
      H5P_cls_close_func_t
      pointer
    ], :hid_t

    attach_function 'H5Pdecode', [
      :pointer
    ], :hid_t

    attach_function 'H5Pencode2', %i[
      hid_t
      pointer
      pointer
      hid_t
    ], :herr_t

    attach_function 'H5Pequal', %i[
      hid_t
      hid_t
    ], :htri_t

    attach_function 'H5Pexist', %i[
      hid_t
      string
    ], :htri_t

    attach_function 'H5Pget', %i[
      hid_t
      string
      pointer
    ], :herr_t

    attach_function 'H5Pget_class', [
      :hid_t
    ], :hid_t

    attach_function 'H5Pget_class_name', [
      :hid_t
    ], :string

    attach_function 'H5Pget_class_parent', [
      :hid_t
    ], :hid_t

    attach_function 'H5Pget_nprops', %i[
      hid_t
      pointer
    ], :herr_t

    attach_function 'H5Pget_size', %i[
      hid_t
      string
      pointer
    ], :herr_t

    attach_function 'H5Pinsert2', %i[
      hid_t
      string
      size_t
      pointer
      H5P_prp_set_func_t
      H5P_prp_get_func_t
      H5P_prp_delete_func_t
      H5P_prp_copy_func_t
      H5P_prp_compare_func_t
      H5P_prp_close_func_t
    ], :herr_t

    attach_function 'H5Pisa_class', %i[
      hid_t
      hid_t
    ], :htri_t

    attach_function 'H5Piterate', %i[
      hid_t
      pointer
      H5P_iterate_t
      pointer
    ], :int

    attach_function 'H5Pregister2', %i[
      hid_t
      string
      size_t
      pointer
      H5P_prp_create_func_t
      H5P_prp_set_func_t
      H5P_prp_get_func_t
      H5P_prp_delete_func_t
      H5P_prp_copy_func_t
      H5P_prp_compare_func_t
      H5P_prp_close_func_t
    ], :herr_t

    attach_function 'H5Premove', %i[
      hid_t
      string
    ], :herr_t

    attach_function 'H5Pset', %i[
      hid_t
      string
      pointer
    ], :herr_t

    attach_function 'H5Punregister', %i[
      hid_t
      string
    ], :herr_t

    attach_function 'H5Pall_filters_avail', [
      :hid_t
    ], :htri_t

    attach_function 'H5Pget_attr_creation_order', %i[
      hid_t
      pointer
    ], :herr_t

    attach_function 'H5Pget_attr_phase_change', %i[
      hid_t
      pointer
      pointer
    ], :herr_t

    attach_function 'H5Pget_filter2', %i[
      hid_t
      uint
      pointer
      pointer
      pointer
      size_t
      string
      pointer
    ], :H5Z_filter_t

    attach_function 'H5Pget_filter_by_id2', %i[
      hid_t
      H5Z_filter_t
      pointer
      pointer
      pointer
      size_t
      string
      pointer
    ], :herr_t

    attach_function 'H5Pget_nfilters', [
      :hid_t
    ], :int

    attach_function 'H5Pget_obj_track_times', %i[
      hid_t
      pointer
    ], :herr_t

    attach_function 'H5Pmodify_filter', %i[
      hid_t
      H5Z_filter_t
      uint
      size_t
      pointer
    ], :herr_t

    attach_function 'H5Premove_filter', %i[
      hid_t
      H5Z_filter_t
    ], :herr_t

    attach_function 'H5Pset_attr_creation_order', %i[
      hid_t
      uint
    ], :herr_t

    attach_function 'H5Pset_attr_phase_change', %i[
      hid_t
      uint
      uint
    ], :herr_t

    attach_function 'H5Pset_deflate', %i[
      hid_t
      uint
    ], :herr_t

    attach_function 'H5Pset_filter', %i[
      hid_t
      H5Z_filter_t
      uint
      size_t
      pointer
    ], :herr_t

    attach_function 'H5Pset_fletcher32', [
      :hid_t
    ], :herr_t

    attach_function 'H5Pset_obj_track_times', %i[
      hid_t
      hbool_t
    ], :herr_t

    attach_function 'H5Pget_file_space_page_size', %i[
      hid_t
      pointer
    ], :herr_t

    attach_function 'H5Pget_file_space_strategy', %i[
      hid_t
      pointer
      pointer
      pointer
    ], :herr_t

    attach_function 'H5Pget_istore_k', %i[
      hid_t
      pointer
    ], :herr_t

    attach_function 'H5Pget_shared_mesg_index', %i[
      hid_t
      uint
      pointer
      pointer
    ], :herr_t

    attach_function 'H5Pget_shared_mesg_nindexes', %i[
      hid_t
      pointer
    ], :herr_t

    attach_function 'H5Pget_shared_mesg_phase_change', %i[
      hid_t
      pointer
      pointer
    ], :herr_t

    attach_function 'H5Pget_sizes', %i[
      hid_t
      pointer
      pointer
    ], :herr_t

    attach_function 'H5Pget_sym_k', %i[
      hid_t
      pointer
      pointer
    ], :herr_t

    attach_function 'H5Pget_userblock', %i[
      hid_t
      pointer
    ], :herr_t

    attach_function 'H5Pset_file_space_page_size', %i[
      hid_t
      hsize_t
    ], :herr_t

    attach_function 'H5Pset_file_space_strategy', %i[
      hid_t
      H5F_fspace_strategy_t
      hbool_t
      hsize_t
    ], :herr_t

    attach_function 'H5Pset_istore_k', %i[
      hid_t
      uint
    ], :herr_t

    attach_function 'H5Pset_shared_mesg_index', %i[
      hid_t
      uint
      uint
      uint
    ], :herr_t

    attach_function 'H5Pset_shared_mesg_nindexes', %i[
      hid_t
      uint
    ], :herr_t

    attach_function 'H5Pset_shared_mesg_phase_change', %i[
      hid_t
      uint
      uint
    ], :herr_t

    attach_function 'H5Pset_sizes', %i[
      hid_t
      size_t
      size_t
    ], :herr_t

    attach_function 'H5Pset_sym_k', %i[
      hid_t
      uint
      uint
    ], :herr_t

    attach_function 'H5Pset_userblock', %i[
      hid_t
      hsize_t
    ], :herr_t

    attach_function 'H5Pget_alignment', %i[
      hid_t
      pointer
      pointer
    ], :herr_t

    attach_function 'H5Pget_cache', %i[
      hid_t
      pointer
      pointer
      pointer
      pointer
    ], :herr_t

    attach_function 'H5Pget_core_write_tracking', %i[
      hid_t
      pointer
      pointer
    ], :herr_t

    attach_function 'H5Pget_driver', [
      :hid_t
    ], :hid_t

    attach_function 'H5Pget_driver_info', [
      :hid_t
    ], :pointer

    attach_function 'H5Pget_driver_config_str', %i[
      hid_t
      string
      size_t
    ], :ssize_t

    attach_function 'H5Pget_elink_file_cache_size', %i[
      hid_t
      pointer
    ], :herr_t

    attach_function 'H5Pget_evict_on_close', %i[
      hid_t
      pointer
    ], :herr_t

    attach_function 'H5Pget_family_offset', %i[
      hid_t
      pointer
    ], :herr_t

    attach_function 'H5Pget_fclose_degree', %i[
      hid_t
      pointer
    ], :herr_t

    attach_function 'H5Pget_file_image', %i[
      hid_t
      pointer
      pointer
    ], :herr_t

    attach_function 'H5Pget_file_image_callbacks', [
      :hid_t,
      H5FDFileImageCallbacksT.ptr
    ], :herr_t

    attach_function 'H5Pget_file_locking', %i[
      hid_t
      pointer
      pointer
    ], :herr_t

    attach_function 'H5Pget_gc_references', %i[
      hid_t
      pointer
    ], :herr_t

    attach_function 'H5Pget_libver_bounds', %i[
      hid_t
      pointer
      pointer
    ], :herr_t

    attach_function 'H5Pget_mdc_config', [
      :hid_t,
      H5ACCacheConfigT.ptr
    ], :herr_t

    attach_function 'H5Pget_mdc_image_config', [
      :hid_t,
      H5ACCacheImageConfigT.ptr
    ], :herr_t

    attach_function 'H5Pget_mdc_log_options', %i[
      hid_t
      pointer
      string
      pointer
      pointer
    ], :herr_t

    attach_function 'H5Pget_meta_block_size', %i[
      hid_t
      pointer
    ], :herr_t

    attach_function 'H5Pget_metadata_read_attempts', %i[
      hid_t
      pointer
    ], :herr_t

    attach_function 'H5Pget_multi_type', %i[
      hid_t
      pointer
    ], :herr_t

    attach_function 'H5Pget_object_flush_cb', %i[
      hid_t
      pointer
      pointer
    ], :herr_t

    attach_function 'H5Pget_page_buffer_size', %i[
      hid_t
      pointer
      pointer
      pointer
    ], :herr_t

    attach_function 'H5Pget_sieve_buf_size', %i[
      hid_t
      pointer
    ], :herr_t

    attach_function 'H5Pget_small_data_block_size', %i[
      hid_t
      pointer
    ], :herr_t

    attach_function 'H5Pget_vol_id', %i[
      hid_t
      pointer
    ], :herr_t

    attach_function 'H5Pget_vol_info', %i[
      hid_t
      pointer
    ], :herr_t

    attach_function 'H5Pset_alignment', %i[
      hid_t
      hsize_t
      hsize_t
    ], :herr_t

    attach_function 'H5Pset_cache', %i[
      hid_t
      int
      size_t
      size_t
      double
    ], :herr_t

    attach_function 'H5Pset_core_write_tracking', %i[
      hid_t
      hbool_t
      size_t
    ], :herr_t

    attach_function 'H5Pset_driver', %i[
      hid_t
      hid_t
      pointer
    ], :herr_t

    attach_function 'H5Pset_driver_by_name', %i[
      hid_t
      string
      string
    ], :herr_t

    attach_function 'H5Pset_driver_by_value', %i[
      hid_t
      H5FD_class_value_t
      string
    ], :herr_t

    attach_function 'H5Pset_elink_file_cache_size', %i[
      hid_t
      uint
    ], :herr_t

    attach_function 'H5Pset_evict_on_close', %i[
      hid_t
      hbool_t
    ], :herr_t

    attach_function 'H5Pset_family_offset', %i[
      hid_t
      hsize_t
    ], :herr_t

    attach_function 'H5Pset_fclose_degree', %i[
      hid_t
      H5F_close_degree_t
    ], :herr_t

    attach_function 'H5Pset_file_image', %i[
      hid_t
      pointer
      size_t
    ], :herr_t

    attach_function 'H5Pset_file_image_callbacks', [
      :hid_t,
      H5FDFileImageCallbacksT.ptr
    ], :herr_t

    attach_function 'H5Pset_file_locking', %i[
      hid_t
      hbool_t
      hbool_t
    ], :herr_t

    attach_function 'H5Pset_gc_references', %i[
      hid_t
      uint
    ], :herr_t

    attach_function 'H5Pset_libver_bounds', %i[
      hid_t
      H5F_libver_t
      H5F_libver_t
    ], :herr_t

    attach_function 'H5Pset_mdc_config', [
      :hid_t,
      H5ACCacheConfigT.ptr
    ], :herr_t

    attach_function 'H5Pset_mdc_log_options', %i[
      hid_t
      hbool_t
      string
      hbool_t
    ], :herr_t

    attach_function 'H5Pset_meta_block_size', %i[
      hid_t
      hsize_t
    ], :herr_t

    attach_function 'H5Pset_metadata_read_attempts', %i[
      hid_t
      uint
    ], :herr_t

    attach_function 'H5Pset_multi_type', %i[
      hid_t
      H5FD_mem_t
    ], :herr_t

    attach_function 'H5Pset_object_flush_cb', %i[
      hid_t
      H5F_flush_cb_t
      pointer
    ], :herr_t

    attach_function 'H5Pset_sieve_buf_size', %i[
      hid_t
      size_t
    ], :herr_t

    attach_function 'H5Pset_small_data_block_size', %i[
      hid_t
      hsize_t
    ], :herr_t

    attach_function 'H5Pset_vol', %i[
      hid_t
      hid_t
      pointer
    ], :herr_t

    attach_function 'H5Pget_vol_cap_flags', %i[
      hid_t
      pointer
    ], :herr_t

    attach_function 'H5Pset_mdc_image_config', [
      :hid_t,
      H5ACCacheImageConfigT.ptr
    ], :herr_t

    attach_function 'H5Pset_page_buffer_size', %i[
      hid_t
      size_t
      uint
      uint
    ], :herr_t

    attach_function 'H5Pset_relax_file_integrity_checks', %i[
      hid_t
      uint64_t
    ], :herr_t

    attach_function 'H5Pget_relax_file_integrity_checks', %i[
      hid_t
      pointer
    ], :herr_t

    attach_function 'H5Pfill_value_defined', %i[
      hid_t
      pointer
    ], :herr_t

    attach_function 'H5Pget_alloc_time', %i[
      hid_t
      pointer
    ], :herr_t

    attach_function 'H5Pget_chunk', %i[
      hid_t
      int
      pointer
    ], :int

    attach_function 'H5Pget_chunk_opts', %i[
      hid_t
      pointer
    ], :herr_t

    attach_function 'H5Pget_dset_no_attrs_hint', %i[
      hid_t
      pointer
    ], :herr_t

    attach_function 'H5Pget_external', %i[
      hid_t
      uint
      size_t
      string
      pointer
      pointer
    ], :herr_t

    attach_function 'H5Pget_external_count', [
      :hid_t
    ], :int

    attach_function 'H5Pget_fill_time', %i[
      hid_t
      pointer
    ], :herr_t

    attach_function 'H5Pget_fill_value', %i[
      hid_t
      hid_t
      pointer
    ], :herr_t

    attach_function 'H5Pget_layout', [
      :hid_t
    ], :H5D_layout_t

    attach_function 'H5Pget_virtual_count', %i[
      hid_t
      pointer
    ], :herr_t

    attach_function 'H5Pget_virtual_dsetname', %i[
      hid_t
      size_t
      string
      size_t
    ], :ssize_t

    attach_function 'H5Pget_virtual_filename', %i[
      hid_t
      size_t
      string
      size_t
    ], :ssize_t

    attach_function 'H5Pget_virtual_srcspace', %i[
      hid_t
      size_t
    ], :hid_t

    attach_function 'H5Pget_virtual_vspace', %i[
      hid_t
      size_t
    ], :hid_t

    attach_function 'H5Pset_alloc_time', %i[
      hid_t
      H5D_alloc_time_t
    ], :herr_t

    attach_function 'H5Pset_chunk', %i[
      hid_t
      int
      pointer
    ], :herr_t

    attach_function 'H5Pset_chunk_opts', %i[
      hid_t
      uint
    ], :herr_t

    attach_function 'H5Pset_dset_no_attrs_hint', %i[
      hid_t
      hbool_t
    ], :herr_t

    attach_function 'H5Pset_external', %i[
      hid_t
      string
      off_t
      hsize_t
    ], :herr_t

    attach_function 'H5Pset_fill_time', %i[
      hid_t
      H5D_fill_time_t
    ], :herr_t

    attach_function 'H5Pset_fill_value', %i[
      hid_t
      hid_t
      pointer
    ], :herr_t

    attach_function 'H5Pset_shuffle', [
      :hid_t
    ], :herr_t

    attach_function 'H5Pset_layout', %i[
      hid_t
      H5D_layout_t
    ], :herr_t

    attach_function 'H5Pset_nbit', [
      :hid_t
    ], :herr_t

    attach_function 'H5Pset_scaleoffset', %i[
      hid_t
      H5Z_SO_scale_type_t
      int
    ], :herr_t

    attach_function 'H5Pset_szip', %i[
      hid_t
      uint
      uint
    ], :herr_t

    attach_function 'H5Pset_virtual', %i[
      hid_t
      hid_t
      string
      string
      hid_t
    ], :herr_t

    attach_function 'H5Pget_append_flush', %i[
      hid_t
      uint
      pointer
      pointer
      pointer
    ], :herr_t

    attach_function 'H5Pget_chunk_cache', %i[
      hid_t
      pointer
      pointer
      pointer
    ], :herr_t

    attach_function 'H5Pget_efile_prefix', %i[
      hid_t
      string
      size_t
    ], :ssize_t

    attach_function 'H5Pget_virtual_prefix', %i[
      hid_t
      string
      size_t
    ], :ssize_t

    attach_function 'H5Pget_virtual_printf_gap', %i[
      hid_t
      pointer
    ], :herr_t

    attach_function 'H5Pget_virtual_view', %i[
      hid_t
      pointer
    ], :herr_t

    attach_function 'H5Pset_append_flush', %i[
      hid_t
      uint
      pointer
      H5D_append_cb_t
      pointer
    ], :herr_t

    attach_function 'H5Pset_chunk_cache', %i[
      hid_t
      size_t
      size_t
      double
    ], :herr_t

    attach_function 'H5Pset_efile_prefix', %i[
      hid_t
      string
    ], :herr_t

    attach_function 'H5Pset_virtual_prefix', %i[
      hid_t
      string
    ], :herr_t

    attach_function 'H5Pset_virtual_printf_gap', %i[
      hid_t
      hsize_t
    ], :herr_t

    attach_function 'H5Pset_virtual_view', %i[
      hid_t
      H5D_vds_view_t
    ], :herr_t

    attach_function 'H5Pget_btree_ratios', %i[
      hid_t
      pointer
      pointer
      pointer
    ], :herr_t

    attach_function 'H5Pget_buffer', %i[
      hid_t
      pointer
      pointer
    ], :size_t

    attach_function 'H5Pget_data_transform', %i[
      hid_t
      string
      size_t
    ], :ssize_t

    attach_function 'H5Pget_edc_check', [
      :hid_t
    ], :H5Z_EDC_t

    attach_function 'H5Pget_hyper_vector_size', %i[
      hid_t
      pointer
    ], :herr_t

    attach_function 'H5Pget_preserve', [
      :hid_t
    ], :int

    attach_function 'H5Pget_type_conv_cb', %i[
      hid_t
      pointer
      pointer
    ], :herr_t

    attach_function 'H5Pget_vlen_mem_manager', %i[
      hid_t
      pointer
      pointer
      pointer
      pointer
    ], :herr_t

    attach_function 'H5Pset_btree_ratios', %i[
      hid_t
      double
      double
      double
    ], :herr_t

    attach_function 'H5Pset_buffer', %i[
      hid_t
      size_t
      pointer
      pointer
    ], :herr_t

    attach_function 'H5Pset_data_transform', %i[
      hid_t
      string
    ], :herr_t

    attach_function 'H5Pset_edc_check', %i[
      hid_t
      H5Z_EDC_t
    ], :herr_t

    attach_function 'H5Pset_filter_callback', %i[
      hid_t
      H5Z_filter_func_t
      pointer
    ], :herr_t

    attach_function 'H5Pset_hyper_vector_size', %i[
      hid_t
      size_t
    ], :herr_t

    attach_function 'H5Pset_preserve', %i[
      hid_t
      hbool_t
    ], :herr_t

    attach_function 'H5Pset_type_conv_cb', %i[
      hid_t
      H5T_conv_except_func_t
      pointer
    ], :herr_t

    attach_function 'H5Pset_vlen_mem_manager', %i[
      hid_t
      H5MM_allocate_t
      pointer
      H5MM_free_t
      pointer
    ], :herr_t

    attach_function 'H5Pset_dataset_io_hyperslab_selection', %i[
      hid_t
      uint
      H5S_seloper_t
      pointer
      pointer
      pointer
      pointer
    ], :herr_t

    attach_function 'H5Pset_selection_io', %i[
      hid_t
      H5D_selection_io_mode_t
    ], :herr_t

    attach_function 'H5Pget_selection_io', %i[
      hid_t
      pointer
    ], :herr_t

    attach_function 'H5Pget_no_selection_io_cause', %i[
      hid_t
      pointer
    ], :herr_t

    attach_function 'H5Pget_actual_selection_io_mode', %i[
      hid_t
      pointer
    ], :herr_t

    attach_function 'H5Pset_modify_write_buf', %i[
      hid_t
      hbool_t
    ], :herr_t

    attach_function 'H5Pget_modify_write_buf', %i[
      hid_t
      pointer
    ], :herr_t

    attach_function 'H5Pget_create_intermediate_group', %i[
      hid_t
      pointer
    ], :herr_t

    attach_function 'H5Pset_create_intermediate_group', %i[
      hid_t
      uint
    ], :herr_t

    attach_function 'H5Pget_est_link_info', %i[
      hid_t
      pointer
      pointer
    ], :herr_t

    attach_function 'H5Pget_link_creation_order', %i[
      hid_t
      pointer
    ], :herr_t

    attach_function 'H5Pget_link_phase_change', %i[
      hid_t
      pointer
      pointer
    ], :herr_t

    attach_function 'H5Pget_local_heap_size_hint', %i[
      hid_t
      pointer
    ], :herr_t

    attach_function 'H5Pset_est_link_info', %i[
      hid_t
      uint
      uint
    ], :herr_t

    attach_function 'H5Pset_link_creation_order', %i[
      hid_t
      uint
    ], :herr_t

    attach_function 'H5Pset_link_phase_change', %i[
      hid_t
      uint
      uint
    ], :herr_t

    attach_function 'H5Pset_local_heap_size_hint', %i[
      hid_t
      size_t
    ], :herr_t

    attach_function 'H5Pget_char_encoding', %i[
      hid_t
      pointer
    ], :herr_t

    attach_function 'H5Pset_char_encoding', %i[
      hid_t
      H5T_cset_t
    ], :herr_t

    attach_function 'H5Pget_elink_acc_flags', %i[
      hid_t
      pointer
    ], :herr_t

    attach_function 'H5Pget_elink_cb', %i[
      hid_t
      pointer
      pointer
    ], :herr_t

    attach_function 'H5Pget_elink_fapl', [
      :hid_t
    ], :hid_t

    attach_function 'H5Pget_elink_prefix', %i[
      hid_t
      string
      size_t
    ], :ssize_t

    attach_function 'H5Pget_nlinks', %i[
      hid_t
      pointer
    ], :herr_t

    attach_function 'H5Pset_elink_acc_flags', %i[
      hid_t
      uint
    ], :herr_t

    attach_function 'H5Pset_elink_cb', %i[
      hid_t
      H5L_elink_traverse_t
      pointer
    ], :herr_t

    attach_function 'H5Pset_elink_fapl', %i[
      hid_t
      hid_t
    ], :herr_t

    attach_function 'H5Pset_elink_prefix', %i[
      hid_t
      string
    ], :herr_t

    attach_function 'H5Pset_nlinks', %i[
      hid_t
      size_t
    ], :herr_t

    attach_function 'H5Padd_merge_committed_dtype_path', %i[
      hid_t
      string
    ], :herr_t

    attach_function 'H5Pfree_merge_committed_dtype_paths', [
      :hid_t
    ], :herr_t

    attach_function 'H5Pget_copy_object', %i[
      hid_t
      pointer
    ], :herr_t

    attach_function 'H5Pget_mcdt_search_cb', %i[
      hid_t
      pointer
      pointer
    ], :herr_t

    attach_function 'H5Pset_copy_object', %i[
      hid_t
      uint
    ], :herr_t

    attach_function 'H5Pset_mcdt_search_cb', %i[
      hid_t
      H5O_mcdt_search_cb_t
      pointer
    ], :herr_t

    attach_function 'H5Pregister1', %i[
      hid_t
      string
      size_t
      pointer
      H5P_prp_create_func_t
      H5P_prp_set_func_t
      H5P_prp_get_func_t
      H5P_prp_delete_func_t
      H5P_prp_copy_func_t
      H5P_prp_close_func_t
    ], :herr_t

    attach_function 'H5Pinsert1', %i[
      hid_t
      string
      size_t
      pointer
      H5P_prp_set_func_t
      H5P_prp_get_func_t
      H5P_prp_delete_func_t
      H5P_prp_copy_func_t
      H5P_prp_close_func_t
    ], :herr_t

    attach_function 'H5Pencode1', %i[
      hid_t
      pointer
      pointer
    ], :herr_t

    attach_function 'H5Pget_filter1', %i[
      hid_t
      uint
      pointer
      pointer
      pointer
      size_t
      string
    ], :H5Z_filter_t

    attach_function 'H5Pget_filter_by_id1', %i[
      hid_t
      H5Z_filter_t
      pointer
      pointer
      pointer
      size_t
      string
    ], :herr_t

    attach_function 'H5Pget_version', %i[
      hid_t
      pointer
      pointer
      pointer
      pointer
    ], :herr_t

    attach_function 'H5Pset_file_space', %i[
      hid_t
      H5F_file_space_type_t
      hsize_t
    ], :herr_t

    attach_function 'H5Pget_file_space', %i[
      hid_t
      pointer
      pointer
    ], :herr_t

    enum :H5PL_type_t, [
      :H5PL_TYPE_ERROR, 4_294_967_295,
      :H5PL_TYPE_FILTER, 0,
      :H5PL_TYPE_VOL, 1,
      :H5PL_TYPE_VFD, 2,
      :H5PL_TYPE_NONE, 3
    ]

    typedef :H5PL_type_t, :H5PL_type_t

    attach_function 'H5PLset_loading_state', [
      :uint
    ], :herr_t

    attach_function 'H5PLget_loading_state', [
      :pointer
    ], :herr_t

    attach_function 'H5PLappend', [
      :string
    ], :herr_t

    attach_function 'H5PLprepend', [
      :string
    ], :herr_t

    attach_function 'H5PLreplace', %i[
      string
      uint
    ], :herr_t

    attach_function 'H5PLinsert', %i[
      string
      uint
    ], :herr_t

    attach_function 'H5PLremove', [
      :uint
    ], :herr_t

    attach_function 'H5PLget', %i[
      uint
      string
      size_t
    ], :ssize_t

    attach_function 'H5PLsize', [
      :pointer
    ], :herr_t

    attach_function 'H5ESinsert_request', %i[
      hid_t
      hid_t
      pointer
    ], :herr_t

    attach_function 'H5ESget_requests', %i[
      hid_t
      H5_iter_order_t
      pointer
      pointer
      size_t
      pointer
    ], :herr_t

    class H5FDT < ::FFI::Struct
    end

    # Already defined? H5FDT

    # H5FDT = H5FDT

    class H5FDClassT < ::FFI::Struct
      layout \
        :version, :uint,
        :value, :H5FD_class_value_t,
        :name, :string,
        :maxaddr, :haddr_t,
        :fc_degree, :H5F_close_degree_t,
        :terminate, :pointer,
        :sb_size, :pointer,
        :sb_encode, :pointer,
        :sb_decode, :pointer,
        :fapl_size, :size_t,
        :fapl_get, :pointer,
        :fapl_copy, :pointer,
        :fapl_free, :pointer,
        :dxpl_size, :size_t,
        :dxpl_copy, :pointer,
        :dxpl_free, :pointer,
        :open, :pointer,
        :close, :pointer,
        :cmp, :pointer,
        :query, :pointer,
        :get_type_map, :pointer,
        :alloc, :pointer,
        :free, :pointer,
        :get_eoa, :pointer,
        :set_eoa, :pointer,
        :get_eof, :pointer,
        :get_handle, :pointer,
        :read, :pointer,
        :write, :pointer,
        :read_vector, :pointer,
        :write_vector, :pointer,
        :read_selection, :pointer,
        :write_selection, :pointer,
        :flush, :pointer,
        :truncate, :pointer,
        :lock, :pointer,
        :unlock, :pointer,
        :del, :pointer,
        :ctl, :pointer,
        :fl_map, [:H5FD_mem_t, 7]
    end

    # H5FDClassT = H5FDClassT

    class H5FDFreeT < ::FFI::Struct
      layout \
        :addr, :haddr_t,
        :size, :hsize_t,
        :next, H5FDFreeT.ptr
    end

    # H5FDFreeT = H5FDFreeT

    # Already defined? H5FDT

    typedef :pointer, :H5FD_init_t

    attach_function 'H5FDperform_init', [
      :H5FD_init_t
    ], :hid_t

    attach_function 'H5FDregister', [
      H5FDClassT.ptr
    ], :hid_t

    attach_function 'H5FDis_driver_registered_by_name', [
      :string
    ], :htri_t

    attach_function 'H5FDis_driver_registered_by_value', [
      :H5FD_class_value_t
    ], :htri_t

    attach_function 'H5FDunregister', [
      :hid_t
    ], :herr_t

    attach_function 'H5FDopen', %i[
      string
      uint
      hid_t
      haddr_t
    ], H5FDT.ptr

    attach_function 'H5FDclose', [
      H5FDT.ptr
    ], :herr_t

    attach_function 'H5FDcmp', [
      H5FDT.ptr,
      H5FDT.ptr
    ], :int

    attach_function 'H5FDquery', [
      H5FDT.ptr,
      :pointer
    ], :int

    attach_function 'H5FDalloc', [
      H5FDT.ptr,
      :H5FD_mem_t,
      :hid_t,
      :hsize_t
    ], :haddr_t

    attach_function 'H5FDfree', [
      H5FDT.ptr,
      :H5FD_mem_t,
      :hid_t,
      :haddr_t,
      :hsize_t
    ], :herr_t

    attach_function 'H5FDget_eoa', [
      H5FDT.ptr,
      :H5FD_mem_t
    ], :haddr_t

    attach_function 'H5FDset_eoa', [
      H5FDT.ptr,
      :H5FD_mem_t,
      :haddr_t
    ], :herr_t

    attach_function 'H5FDget_eof', [
      H5FDT.ptr,
      :H5FD_mem_t
    ], :haddr_t

    attach_function 'H5FDget_vfd_handle', [
      H5FDT.ptr,
      :hid_t,
      :pointer
    ], :herr_t

    attach_function 'H5FDread', [
      H5FDT.ptr,
      :H5FD_mem_t,
      :hid_t,
      :haddr_t,
      :size_t,
      :pointer
    ], :herr_t

    attach_function 'H5FDwrite', [
      H5FDT.ptr,
      :H5FD_mem_t,
      :hid_t,
      :haddr_t,
      :size_t,
      :pointer
    ], :herr_t

    attach_function 'H5FDread_vector', [
      H5FDT.ptr,
      :hid_t,
      :uint32_t,
      :pointer,
      :pointer,
      :pointer,
      :pointer
    ], :herr_t

    attach_function 'H5FDwrite_vector', [
      H5FDT.ptr,
      :hid_t,
      :uint32_t,
      :pointer,
      :pointer,
      :pointer,
      :pointer
    ], :herr_t

    attach_function 'H5FDread_selection', [
      H5FDT.ptr,
      :H5FD_mem_t,
      :hid_t,
      :uint32_t,
      :pointer,
      :pointer,
      :pointer,
      :pointer,
      :pointer
    ], :herr_t

    attach_function 'H5FDwrite_selection', [
      H5FDT.ptr,
      :H5FD_mem_t,
      :hid_t,
      :uint32_t,
      :pointer,
      :pointer,
      :pointer,
      :pointer,
      :pointer
    ], :herr_t

    attach_function 'H5FDread_vector_from_selection', [
      H5FDT.ptr,
      :H5FD_mem_t,
      :hid_t,
      :uint32_t,
      :pointer,
      :pointer,
      :pointer,
      :pointer,
      :pointer
    ], :herr_t

    attach_function 'H5FDwrite_vector_from_selection', [
      H5FDT.ptr,
      :H5FD_mem_t,
      :hid_t,
      :uint32_t,
      :pointer,
      :pointer,
      :pointer,
      :pointer,
      :pointer
    ], :herr_t

    attach_function 'H5FDread_from_selection', [
      H5FDT.ptr,
      :H5FD_mem_t,
      :hid_t,
      :uint32_t,
      :pointer,
      :pointer,
      :pointer,
      :pointer,
      :pointer
    ], :herr_t

    attach_function 'H5FDwrite_from_selection', [
      H5FDT.ptr,
      :H5FD_mem_t,
      :hid_t,
      :uint32_t,
      :pointer,
      :pointer,
      :pointer,
      :pointer,
      :pointer
    ], :herr_t

    attach_function 'H5FDflush', [
      H5FDT.ptr,
      :hid_t,
      :hbool_t
    ], :herr_t

    attach_function 'H5FDtruncate', [
      H5FDT.ptr,
      :hid_t,
      :hbool_t
    ], :herr_t

    attach_function 'H5FDlock', [
      H5FDT.ptr,
      :hbool_t
    ], :herr_t

    attach_function 'H5FDunlock', [
      H5FDT.ptr
    ], :herr_t

    attach_function 'H5FDdelete', %i[
      string
      hid_t
    ], :herr_t

    attach_function 'H5FDctl', [
      H5FDT.ptr,
      :uint64_t,
      :uint64_t,
      :pointer,
      :pointer
    ], :herr_t

    typedef :pointer, :H5I_future_realize_func_t

    typedef :pointer, :H5I_future_discard_func_t

    attach_function 'H5Iregister_future', %i[
      H5I_type_t
      pointer
      H5I_future_realize_func_t
      H5I_future_discard_func_t
    ], :hid_t

    typedef :pointer, :H5L_create_func_t

    typedef :pointer, :H5L_move_func_t

    typedef :pointer, :H5L_copy_func_t

    typedef :pointer, :H5L_traverse_func_t

    typedef :pointer, :H5L_delete_func_t

    typedef :pointer, :H5L_query_func_t

    class Anon_Type_126 < ::FFI::Struct
      layout \
        :version, :int,
        :id, :H5L_type_t,
        :comment, :string,
        :create_func, :H5L_create_func_t,
        :move_func, :H5L_move_func_t,
        :copy_func, :H5L_copy_func_t,
        :trav_func, :H5L_traverse_func_t,
        :del_func, :H5L_delete_func_t,
        :query_func, :H5L_query_func_t
    end

    H5LClassT = Anon_Type_126

    attach_function 'H5Lregister', [
      H5LClassT.ptr
    ], :herr_t

    attach_function 'H5Lunregister', [
      :H5L_type_t
    ], :herr_t

    typedef :pointer, :H5L_traverse_0_func_t

    class Anon_Type_127 < ::FFI::Struct
      layout \
        :version, :int,
        :id, :H5L_type_t,
        :comment, :string,
        :create_func, :H5L_create_func_t,
        :move_func, :H5L_move_func_t,
        :copy_func, :H5L_copy_func_t,
        :trav_func, :H5L_traverse_0_func_t,
        :del_func, :H5L_delete_func_t,
        :query_func, :H5L_query_func_t
    end

    H5LClass_0T = Anon_Type_127

    enum :H5T_cmd_t, [
      :H5T_CONV_INIT, 0,
      :H5T_CONV_CONV, 1,
      :H5T_CONV_FREE, 2
    ]

    typedef :H5T_cmd_t, :H5T_cmd_t

    enum :H5T_bkg_t, [
      :H5T_BKG_NO, 0,
      :H5T_BKG_TEMP, 1,
      :H5T_BKG_YES, 2
    ]

    typedef :H5T_bkg_t, :H5T_bkg_t

    class H5TCdataT < ::FFI::Struct
      layout \
        :command, :H5T_cmd_t,
        :need_bkg, :H5T_bkg_t,
        :recalc, :hbool_t,
        :priv, :pointer
    end

    # H5TCdataT = H5TCdataT

    enum :H5T_pers_t, [
      :H5T_PERS_DONTCARE, 4_294_967_295,
      :H5T_PERS_HARD, 0,
      :H5T_PERS_SOFT, 1
    ]

    typedef :H5T_pers_t, :H5T_pers_t

    typedef :pointer, :H5T_conv_t

    attach_function 'H5Tregister', %i[
      H5T_pers_t
      string
      hid_t
      hid_t
      H5T_conv_t
    ], :herr_t

    attach_function 'H5Tunregister', %i[
      H5T_pers_t
      string
      hid_t
      hid_t
      H5T_conv_t
    ], :herr_t

    attach_function 'H5Tfind', %i[
      hid_t
      hid_t
      pointer
    ], :H5T_conv_t

    attach_function 'H5Tcompiler_conv', %i[
      hid_t
      hid_t
    ], :htri_t

    attach_function 'H5TSmutex_acquire', %i[
      uint
      pointer
    ], :herr_t

    attach_function 'H5TSmutex_release', [
      :pointer
    ], :herr_t

    attach_function 'H5TSmutex_get_attempt_count', [
      :pointer
    ], :herr_t

    class H5ZCbT < ::FFI::Struct
      layout \
        :func, :H5Z_filter_func_t,
        :op_data, :pointer
    end

    # H5ZCbT = H5ZCbT

    typedef :pointer, :H5Z_can_apply_func_t

    typedef :pointer, :H5Z_set_local_func_t

    typedef :pointer, :H5Z_func_t

    class H5ZClass2T < ::FFI::Struct
      layout \
        :version, :int,
        :id, :H5Z_filter_t,
        :encoder_present, :uint,
        :decoder_present, :uint,
        :name, :string,
        :can_apply, :H5Z_can_apply_func_t,
        :set_local, :H5Z_set_local_func_t,
        :filter, :H5Z_func_t
    end

    # H5ZClass2T = H5ZClass2T

    attach_function 'H5Zregister', [
      :pointer
    ], :herr_t

    attach_function 'H5Zunregister', [
      :H5Z_filter_t
    ], :herr_t

    class H5ZClass1T < ::FFI::Struct
      layout \
        :id, :H5Z_filter_t,
        :name, :string,
        :can_apply, :H5Z_can_apply_func_t,
        :set_local, :H5Z_set_local_func_t,
        :filter, :H5Z_func_t
    end

    # H5ZClass1T = H5ZClass1T

    attach_function 'H5VLcmp_connector_cls', %i[
      pointer
      hid_t
      hid_t
    ], :herr_t

    attach_function 'H5VLwrap_register', %i[
      pointer
      H5I_type_t
    ], :hid_t

    attach_function 'H5VLretrieve_lib_state', [
      :pointer
    ], :herr_t

    attach_function 'H5VLstart_lib_state', [], :herr_t

    attach_function 'H5VLrestore_lib_state', [
      :pointer
    ], :herr_t

    attach_function 'H5VLfinish_lib_state', [], :herr_t

    attach_function 'H5VLfree_lib_state', [
      :pointer
    ], :herr_t

    attach_function 'H5VLget_object', %i[
      pointer
      hid_t
    ], :pointer

    attach_function 'H5VLget_wrap_ctx', %i[
      pointer
      hid_t
      pointer
    ], :herr_t

    attach_function 'H5VLwrap_object', %i[
      pointer
      H5I_type_t
      hid_t
      pointer
    ], :pointer

    attach_function 'H5VLunwrap_object', %i[
      pointer
      hid_t
    ], :pointer

    attach_function 'H5VLfree_wrap_ctx', %i[
      pointer
      hid_t
    ], :herr_t

    attach_function 'H5VLinitialize', %i[
      hid_t
      hid_t
    ], :herr_t

    attach_function 'H5VLterminate', [
      :hid_t
    ], :herr_t

    attach_function 'H5VLget_cap_flags', %i[
      hid_t
      pointer
    ], :herr_t

    attach_function 'H5VLget_value', %i[
      hid_t
      pointer
    ], :herr_t

    attach_function 'H5VLcopy_connector_info', %i[
      hid_t
      pointer
      pointer
    ], :herr_t

    attach_function 'H5VLcmp_connector_info', %i[
      pointer
      hid_t
      pointer
      pointer
    ], :herr_t

    attach_function 'H5VLfree_connector_info', %i[
      hid_t
      pointer
    ], :herr_t

    attach_function 'H5VLconnector_info_to_str', %i[
      pointer
      hid_t
      pointer
    ], :herr_t

    attach_function 'H5VLconnector_str_to_info', %i[
      string
      hid_t
      pointer
    ], :herr_t

    attach_function 'H5VLattr_create', [
      :pointer,
      H5VLLocParamsT.ptr,
      :hid_t,
      :string,
      :hid_t,
      :hid_t,
      :hid_t,
      :hid_t,
      :hid_t,
      :pointer
    ], :pointer

    attach_function 'H5VLattr_open', [
      :pointer,
      H5VLLocParamsT.ptr,
      :hid_t,
      :string,
      :hid_t,
      :hid_t,
      :pointer
    ], :pointer

    attach_function 'H5VLattr_read', %i[
      pointer
      hid_t
      hid_t
      pointer
      hid_t
      pointer
    ], :herr_t

    attach_function 'H5VLattr_write', %i[
      pointer
      hid_t
      hid_t
      pointer
      hid_t
      pointer
    ], :herr_t

    attach_function 'H5VLattr_get', [
      :pointer,
      :hid_t,
      H5VLAttrGetArgsT.ptr,
      :hid_t,
      :pointer
    ], :herr_t

    attach_function 'H5VLattr_specific', [
      :pointer,
      H5VLLocParamsT.ptr,
      :hid_t,
      H5VLAttrSpecificArgsT.ptr,
      :hid_t,
      :pointer
    ], :herr_t

    attach_function 'H5VLattr_optional', [
      :pointer,
      :hid_t,
      H5VLOptionalArgsT.ptr,
      :hid_t,
      :pointer
    ], :herr_t

    attach_function 'H5VLattr_close', %i[
      pointer
      hid_t
      hid_t
      pointer
    ], :herr_t

    attach_function 'H5VLdataset_create', [
      :pointer,
      H5VLLocParamsT.ptr,
      :hid_t,
      :string,
      :hid_t,
      :hid_t,
      :hid_t,
      :hid_t,
      :hid_t,
      :hid_t,
      :pointer
    ], :pointer

    attach_function 'H5VLdataset_open', [
      :pointer,
      H5VLLocParamsT.ptr,
      :hid_t,
      :string,
      :hid_t,
      :hid_t,
      :pointer
    ], :pointer

    attach_function 'H5VLdataset_read', %i[
      size_t
      pointer
      hid_t
      pointer
      pointer
      pointer
      hid_t
      pointer
      pointer
    ], :herr_t

    attach_function 'H5VLdataset_write', %i[
      size_t
      pointer
      hid_t
      pointer
      pointer
      pointer
      hid_t
      pointer
      pointer
    ], :herr_t

    attach_function 'H5VLdataset_get', [
      :pointer,
      :hid_t,
      H5VLDatasetGetArgsT.ptr,
      :hid_t,
      :pointer
    ], :herr_t

    attach_function 'H5VLdataset_specific', [
      :pointer,
      :hid_t,
      H5VLDatasetSpecificArgsT.ptr,
      :hid_t,
      :pointer
    ], :herr_t

    attach_function 'H5VLdataset_optional', [
      :pointer,
      :hid_t,
      H5VLOptionalArgsT.ptr,
      :hid_t,
      :pointer
    ], :herr_t

    attach_function 'H5VLdataset_close', %i[
      pointer
      hid_t
      hid_t
      pointer
    ], :herr_t

    attach_function 'H5VLdatatype_commit', [
      :pointer,
      H5VLLocParamsT.ptr,
      :hid_t,
      :string,
      :hid_t,
      :hid_t,
      :hid_t,
      :hid_t,
      :hid_t,
      :pointer
    ], :pointer

    attach_function 'H5VLdatatype_open', [
      :pointer,
      H5VLLocParamsT.ptr,
      :hid_t,
      :string,
      :hid_t,
      :hid_t,
      :pointer
    ], :pointer

    attach_function 'H5VLdatatype_get', [
      :pointer,
      :hid_t,
      H5VLDatatypeGetArgsT.ptr,
      :hid_t,
      :pointer
    ], :herr_t

    attach_function 'H5VLdatatype_specific', [
      :pointer,
      :hid_t,
      H5VLDatatypeSpecificArgsT.ptr,
      :hid_t,
      :pointer
    ], :herr_t

    attach_function 'H5VLdatatype_optional', [
      :pointer,
      :hid_t,
      H5VLOptionalArgsT.ptr,
      :hid_t,
      :pointer
    ], :herr_t

    attach_function 'H5VLdatatype_close', %i[
      pointer
      hid_t
      hid_t
      pointer
    ], :herr_t

    attach_function 'H5VLfile_create', %i[
      string
      uint
      hid_t
      hid_t
      hid_t
      pointer
    ], :pointer

    attach_function 'H5VLfile_open', %i[
      string
      uint
      hid_t
      hid_t
      pointer
    ], :pointer

    attach_function 'H5VLfile_get', [
      :pointer,
      :hid_t,
      H5VLFileGetArgsT.ptr,
      :hid_t,
      :pointer
    ], :herr_t

    attach_function 'H5VLfile_specific', [
      :pointer,
      :hid_t,
      H5VLFileSpecificArgsT.ptr,
      :hid_t,
      :pointer
    ], :herr_t

    attach_function 'H5VLfile_optional', [
      :pointer,
      :hid_t,
      H5VLOptionalArgsT.ptr,
      :hid_t,
      :pointer
    ], :herr_t

    attach_function 'H5VLfile_close', %i[
      pointer
      hid_t
      hid_t
      pointer
    ], :herr_t

    attach_function 'H5VLgroup_create', [
      :pointer,
      H5VLLocParamsT.ptr,
      :hid_t,
      :string,
      :hid_t,
      :hid_t,
      :hid_t,
      :hid_t,
      :pointer
    ], :pointer

    attach_function 'H5VLgroup_open', [
      :pointer,
      H5VLLocParamsT.ptr,
      :hid_t,
      :string,
      :hid_t,
      :hid_t,
      :pointer
    ], :pointer

    attach_function 'H5VLgroup_get', [
      :pointer,
      :hid_t,
      H5VLGroupGetArgsT.ptr,
      :hid_t,
      :pointer
    ], :herr_t

    attach_function 'H5VLgroup_specific', [
      :pointer,
      :hid_t,
      H5VLGroupSpecificArgsT.ptr,
      :hid_t,
      :pointer
    ], :herr_t

    attach_function 'H5VLgroup_optional', [
      :pointer,
      :hid_t,
      H5VLOptionalArgsT.ptr,
      :hid_t,
      :pointer
    ], :herr_t

    attach_function 'H5VLgroup_close', %i[
      pointer
      hid_t
      hid_t
      pointer
    ], :herr_t

    attach_function 'H5VLlink_create', [
      H5VLLinkCreateArgsT.ptr,
      :pointer,
      H5VLLocParamsT.ptr,
      :hid_t,
      :hid_t,
      :hid_t,
      :hid_t,
      :pointer
    ], :herr_t

    attach_function 'H5VLlink_copy', [
      :pointer,
      H5VLLocParamsT.ptr,
      :pointer,
      H5VLLocParamsT.ptr,
      :hid_t,
      :hid_t,
      :hid_t,
      :hid_t,
      :pointer
    ], :herr_t

    attach_function 'H5VLlink_move', [
      :pointer,
      H5VLLocParamsT.ptr,
      :pointer,
      H5VLLocParamsT.ptr,
      :hid_t,
      :hid_t,
      :hid_t,
      :hid_t,
      :pointer
    ], :herr_t

    attach_function 'H5VLlink_get', [
      :pointer,
      H5VLLocParamsT.ptr,
      :hid_t,
      H5VLLinkGetArgsT.ptr,
      :hid_t,
      :pointer
    ], :herr_t

    attach_function 'H5VLlink_specific', [
      :pointer,
      H5VLLocParamsT.ptr,
      :hid_t,
      H5VLLinkSpecificArgsT.ptr,
      :hid_t,
      :pointer
    ], :herr_t

    attach_function 'H5VLlink_optional', [
      :pointer,
      H5VLLocParamsT.ptr,
      :hid_t,
      H5VLOptionalArgsT.ptr,
      :hid_t,
      :pointer
    ], :herr_t

    attach_function 'H5VLobject_open', [
      :pointer,
      H5VLLocParamsT.ptr,
      :hid_t,
      :pointer,
      :hid_t,
      :pointer
    ], :pointer

    attach_function 'H5VLobject_copy', [
      :pointer,
      H5VLLocParamsT.ptr,
      :string,
      :pointer,
      H5VLLocParamsT.ptr,
      :string,
      :hid_t,
      :hid_t,
      :hid_t,
      :hid_t,
      :pointer
    ], :herr_t

    attach_function 'H5VLobject_get', [
      :pointer,
      H5VLLocParamsT.ptr,
      :hid_t,
      H5VLObjectGetArgsT.ptr,
      :hid_t,
      :pointer
    ], :herr_t

    attach_function 'H5VLobject_specific', [
      :pointer,
      H5VLLocParamsT.ptr,
      :hid_t,
      H5VLObjectSpecificArgsT.ptr,
      :hid_t,
      :pointer
    ], :herr_t

    attach_function 'H5VLobject_optional', [
      :pointer,
      H5VLLocParamsT.ptr,
      :hid_t,
      H5VLOptionalArgsT.ptr,
      :hid_t,
      :pointer
    ], :herr_t

    attach_function 'H5VLintrospect_get_conn_cls', %i[
      pointer
      hid_t
      H5VL_get_conn_lvl_t
      pointer
    ], :herr_t

    attach_function 'H5VLintrospect_get_cap_flags', %i[
      pointer
      hid_t
      pointer
    ], :herr_t

    attach_function 'H5VLintrospect_opt_query', %i[
      pointer
      hid_t
      H5VL_subclass_t
      int
      pointer
    ], :herr_t

    attach_function 'H5VLrequest_wait', %i[
      pointer
      hid_t
      uint64_t
      pointer
    ], :herr_t

    attach_function 'H5VLrequest_notify', %i[
      pointer
      hid_t
      H5VL_request_notify_t
      pointer
    ], :herr_t

    attach_function 'H5VLrequest_cancel', %i[
      pointer
      hid_t
      pointer
    ], :herr_t

    attach_function 'H5VLrequest_specific', [
      :pointer,
      :hid_t,
      H5VLRequestSpecificArgsT.ptr
    ], :herr_t

    attach_function 'H5VLrequest_optional', [
      :pointer,
      :hid_t,
      H5VLOptionalArgsT.ptr
    ], :herr_t

    attach_function 'H5VLrequest_free', %i[
      pointer
      hid_t
    ], :herr_t

    attach_function 'H5VLblob_put', %i[
      pointer
      hid_t
      pointer
      size_t
      pointer
      pointer
    ], :herr_t

    attach_function 'H5VLblob_get', %i[
      pointer
      hid_t
      pointer
      pointer
      size_t
      pointer
    ], :herr_t

    attach_function 'H5VLblob_specific', [
      :pointer,
      :hid_t,
      :pointer,
      H5VLBlobSpecificArgsT.ptr
    ], :herr_t

    attach_function 'H5VLblob_optional', [
      :pointer,
      :hid_t,
      :pointer,
      H5VLOptionalArgsT.ptr
    ], :herr_t

    attach_function 'H5VLtoken_cmp', [
      :pointer,
      :hid_t,
      H5OTokenT.ptr,
      H5OTokenT.ptr,
      :pointer
    ], :herr_t

    attach_function 'H5VLtoken_to_str', [
      :pointer,
      :H5I_type_t,
      :hid_t,
      H5OTokenT.ptr,
      :pointer
    ], :herr_t

    attach_function 'H5VLtoken_from_str', [
      :pointer,
      :H5I_type_t,
      :hid_t,
      :string,
      H5OTokenT.ptr
    ], :herr_t

    attach_function 'H5VLoptional', [
      :pointer,
      :hid_t,
      H5VLOptionalArgsT.ptr,
      :hid_t,
      :pointer
    ], :herr_t

    class H5VLNativeAttrIterateOldT < ::FFI::Struct
      layout \
        :loc_id, :hid_t,
        :attr_num, :pointer,
        :op, :H5A_operator1_t,
        :op_data, :pointer
    end

    # H5VLNativeAttrIterateOldT = H5VLNativeAttrIterateOldT

    class H5VLNativeAttrOptionalArgsT < ::FFI::Union
      layout \
        :iterate_old, H5VLNativeAttrIterateOldT
    end

    # H5VLNativeAttrOptionalArgsT = H5VLNativeAttrOptionalArgsT

    class H5VLNativeDatasetChunkReadT < ::FFI::Struct
      layout \
        :offset, :pointer,
        :filters, :uint32_t,
        :buf, :pointer
    end

    # H5VLNativeDatasetChunkReadT = H5VLNativeDatasetChunkReadT

    class H5VLNativeDatasetChunkWriteT < ::FFI::Struct
      layout \
        :offset, :pointer,
        :filters, :uint32_t,
        :size, :uint32_t,
        :buf, :pointer
    end

    # H5VLNativeDatasetChunkWriteT = H5VLNativeDatasetChunkWriteT

    class H5VLNativeDatasetGetVlenBufSizeT < ::FFI::Struct
      layout \
        :type_id, :hid_t,
        :space_id, :hid_t,
        :size, :pointer
    end

    # H5VLNativeDatasetGetVlenBufSizeT = H5VLNativeDatasetGetVlenBufSizeT

    class H5VLNativeDatasetGetChunkStorageSizeT < ::FFI::Struct
      layout \
        :offset, :pointer,
        :size, :pointer
    end

    # H5VLNativeDatasetGetChunkStorageSizeT = H5VLNativeDatasetGetChunkStorageSizeT

    class H5VLNativeDatasetGetNumChunksT < ::FFI::Struct
      layout \
        :space_id, :hid_t,
        :nchunks, :pointer
    end

    # H5VLNativeDatasetGetNumChunksT = H5VLNativeDatasetGetNumChunksT

    class H5VLNativeDatasetGetChunkInfoByIdxT < ::FFI::Struct
      layout \
        :space_id, :hid_t,
        :chk_index, :hsize_t,
        :offset, :pointer,
        :filter_mask, :pointer,
        :addr, :pointer,
        :size, :pointer
    end

    # H5VLNativeDatasetGetChunkInfoByIdxT = H5VLNativeDatasetGetChunkInfoByIdxT

    class H5VLNativeDatasetGetChunkInfoByCoordT < ::FFI::Struct
      layout \
        :offset, :pointer,
        :filter_mask, :pointer,
        :addr, :pointer,
        :size, :pointer
    end

    # H5VLNativeDatasetGetChunkInfoByCoordT = H5VLNativeDatasetGetChunkInfoByCoordT

    class Anon_Type_128 < ::FFI::Struct
      layout \
        :idx_type, :pointer
    end

    class Anon_Type_129 < ::FFI::Struct
      layout \
        :offset, :pointer
    end

    class Anon_Type_130 < ::FFI::Struct
      layout \
        :op, :H5D_chunk_iter_op_t,
        :op_data, :pointer
    end

    class H5VLNativeDatasetOptionalArgsT < ::FFI::Union
      layout \
        :get_chunk_idx_type, Anon_Type_128,
        :get_chunk_storage_size, H5VLNativeDatasetGetChunkStorageSizeT,
        :get_num_chunks, H5VLNativeDatasetGetNumChunksT,
        :get_chunk_info_by_idx, H5VLNativeDatasetGetChunkInfoByIdxT,
        :get_chunk_info_by_coord, H5VLNativeDatasetGetChunkInfoByCoordT,
        :chunk_read, H5VLNativeDatasetChunkReadT,
        :chunk_write, H5VLNativeDatasetChunkWriteT,
        :get_vlen_buf_size, H5VLNativeDatasetGetVlenBufSizeT,
        :get_offset, Anon_Type_129,
        :chunk_iter, Anon_Type_130
    end

    # H5VLNativeDatasetOptionalArgsT = H5VLNativeDatasetOptionalArgsT

    class H5VLNativeFileGetFileImageT < ::FFI::Struct
      layout \
        :buf_size, :size_t,
        :buf, :pointer,
        :image_len, :pointer
    end

    # H5VLNativeFileGetFileImageT = H5VLNativeFileGetFileImageT

    class H5VLNativeFileGetFreeSectionsT < ::FFI::Struct
      layout \
        :type, :H5F_mem_t,
        :sect_info, H5FSectInfoT.ptr,
        :nsects, :size_t,
        :sect_count, :pointer
    end

    # H5VLNativeFileGetFreeSectionsT = H5VLNativeFileGetFreeSectionsT

    class H5VLNativeFileGetFreespaceT < ::FFI::Struct
      layout \
        :size, :pointer
    end

    # H5VLNativeFileGetFreespaceT = H5VLNativeFileGetFreespaceT

    class H5VLNativeFileGetInfoT < ::FFI::Struct
      layout \
        :type, :H5I_type_t,
        :finfo, H5FInfo2T.ptr
    end

    # H5VLNativeFileGetInfoT = H5VLNativeFileGetInfoT

    class H5VLNativeFileGetMdcSizeT < ::FFI::Struct
      layout \
        :max_size, :pointer,
        :min_clean_size, :pointer,
        :cur_size, :pointer,
        :cur_num_entries, :pointer
    end

    # H5VLNativeFileGetMdcSizeT = H5VLNativeFileGetMdcSizeT

    class H5VLNativeFileGetVfdHandleT < ::FFI::Struct
      layout \
        :fapl_id, :hid_t,
        :file_handle, :pointer
    end

    # H5VLNativeFileGetVfdHandleT = H5VLNativeFileGetVfdHandleT

    class H5VLNativeFileGetMdcLoggingStatusT < ::FFI::Struct
      layout \
        :is_enabled, :pointer,
        :is_currently_logging, :pointer
    end

    # H5VLNativeFileGetMdcLoggingStatusT = H5VLNativeFileGetMdcLoggingStatusT

    class H5VLNativeFileGetPageBufferingStatsT < ::FFI::Struct
      layout \
        :accesses, :pointer,
        :hits, :pointer,
        :misses, :pointer,
        :evictions, :pointer,
        :bypasses, :pointer
    end

    # H5VLNativeFileGetPageBufferingStatsT = H5VLNativeFileGetPageBufferingStatsT

    class H5VLNativeFileGetMdcImageInfoT < ::FFI::Struct
      layout \
        :addr, :pointer,
        :len, :pointer
    end

    # H5VLNativeFileGetMdcImageInfoT = H5VLNativeFileGetMdcImageInfoT

    class H5VLNativeFileSetLibverBoundsT < ::FFI::Struct
      layout \
        :low, :H5F_libver_t,
        :high, :H5F_libver_t
    end

    # H5VLNativeFileSetLibverBoundsT = H5VLNativeFileSetLibverBoundsT

    class Anon_Type_131 < ::FFI::Struct
      layout \
        :config, H5ACCacheConfigT.ptr
    end

    class Anon_Type_132 < ::FFI::Struct
      layout \
        :hit_rate, :pointer
    end

    class Anon_Type_133 < ::FFI::Struct
      layout \
        :size, :pointer
    end

    class Anon_Type_134 < ::FFI::Struct
      layout \
        :config, H5ACCacheConfigT.ptr
    end

    class Anon_Type_135 < ::FFI::Struct
      layout \
        :info, H5FRetryInfoT.ptr
    end

    class Anon_Type_136 < ::FFI::Struct
      layout \
        :eoa, :pointer
    end

    class Anon_Type_137 < ::FFI::Struct
      layout \
        :increment, :hsize_t
    end

    class Anon_Type_138 < ::FFI::Struct
      layout \
        :minimize, :pointer
    end

    class Anon_Type_139 < ::FFI::Struct
      layout \
        :minimize, :hbool_t
    end

    class H5VLNativeFileOptionalArgsT < ::FFI::Union
      layout \
        :get_file_image, H5VLNativeFileGetFileImageT,
        :get_free_sections, H5VLNativeFileGetFreeSectionsT,
        :get_freespace, H5VLNativeFileGetFreespaceT,
        :get_info, H5VLNativeFileGetInfoT,
        :get_mdc_config, Anon_Type_131,
        :get_mdc_hit_rate, Anon_Type_132,
        :get_mdc_size, H5VLNativeFileGetMdcSizeT,
        :get_size, Anon_Type_133,
        :get_vfd_handle, H5VLNativeFileGetVfdHandleT,
        :set_mdc_config, Anon_Type_134,
        :get_metadata_read_retry_info, Anon_Type_135,
        :get_mdc_logging_status, H5VLNativeFileGetMdcLoggingStatusT,
        :get_page_buffering_stats, H5VLNativeFileGetPageBufferingStatsT,
        :get_mdc_image_info, H5VLNativeFileGetMdcImageInfoT,
        :get_eoa, Anon_Type_136,
        :increment_filesize, Anon_Type_137,
        :set_libver_bounds, H5VLNativeFileSetLibverBoundsT,
        :get_min_dset_ohdr_flag, Anon_Type_138,
        :set_min_dset_ohdr_flag, Anon_Type_139
    end

    # H5VLNativeFileOptionalArgsT = H5VLNativeFileOptionalArgsT

    class H5VLNativeGroupIterateOldT < ::FFI::Struct
      layout \
        :loc_params, H5VLLocParamsT,
        :idx, :hsize_t,
        :last_obj, :pointer,
        :op, :H5G_iterate_t,
        :op_data, :pointer
    end

    # H5VLNativeGroupIterateOldT = H5VLNativeGroupIterateOldT

    class H5VLNativeGroupGetObjinfoT < ::FFI::Struct
      layout \
        :loc_params, H5VLLocParamsT,
        :follow_link, :hbool_t,
        :statbuf, H5GStatT.ptr
    end

    # H5VLNativeGroupGetObjinfoT = H5VLNativeGroupGetObjinfoT

    class H5VLNativeGroupOptionalArgsT < ::FFI::Union
      layout \
        :iterate_old, H5VLNativeGroupIterateOldT,
        :get_objinfo, H5VLNativeGroupGetObjinfoT
    end

    # H5VLNativeGroupOptionalArgsT = H5VLNativeGroupOptionalArgsT

    class H5VLNativeObjectGetCommentT < ::FFI::Struct
      layout \
        :buf_size, :size_t,
        :buf, :pointer,
        :comment_len, :pointer
    end

    # H5VLNativeObjectGetCommentT = H5VLNativeObjectGetCommentT

    class H5VLNativeObjectGetNativeInfoT < ::FFI::Struct
      layout \
        :fields, :uint,
        :ninfo, H5ONativeInfoT.ptr
    end

    # H5VLNativeObjectGetNativeInfoT = H5VLNativeObjectGetNativeInfoT

    class Anon_Type_140 < ::FFI::Struct
      layout \
        :comment, :string
    end

    class Anon_Type_141 < ::FFI::Struct
      layout \
        :flag, :pointer
    end

    class H5VLNativeObjectOptionalArgsT < ::FFI::Union
      layout \
        :get_comment, H5VLNativeObjectGetCommentT,
        :set_comment, Anon_Type_140,
        :are_mdc_flushes_disabled, Anon_Type_141,
        :get_native_info, H5VLNativeObjectGetNativeInfoT
    end

    # H5VLNativeObjectOptionalArgsT = H5VLNativeObjectOptionalArgsT

    attach_function 'H5VLnative_addr_to_token', [
      :hid_t,
      :haddr_t,
      H5OTokenT.ptr
    ], :herr_t

    attach_function 'H5VLnative_token_to_addr', [
      :hid_t,
      H5OTokenT,
      :pointer
    ], :herr_t

    attach_function 'H5VL_native_register', [], :hid_t

    attach_function 'H5FD_core_init', [], :hid_t

    attach_function 'H5Pset_fapl_core', %i[
      hid_t
      size_t
      hbool_t
    ], :herr_t

    attach_function 'H5Pget_fapl_core', %i[
      hid_t
      pointer
      pointer
    ], :herr_t

    attach_function 'H5FD_family_init', [], :hid_t

    attach_function 'H5Pset_fapl_family', %i[
      hid_t
      hsize_t
      hid_t
    ], :herr_t

    attach_function 'H5Pget_fapl_family', %i[
      hid_t
      pointer
      pointer
    ], :herr_t

    attach_function 'H5FD_log_init', [], :hid_t

    attach_function 'H5Pset_fapl_log', %i[
      hid_t
      string
      ulong_long
      size_t
    ], :herr_t

    enum :H5FD_mpio_xfer_t, [
      :H5FD_MPIO_INDEPENDENT, 0,
      :H5FD_MPIO_COLLECTIVE, 1
    ]

    typedef :H5FD_mpio_xfer_t, :H5FD_mpio_xfer_t

    enum :H5FD_mpio_chunk_opt_t, [
      :H5FD_MPIO_CHUNK_DEFAULT, 0,
      :H5FD_MPIO_CHUNK_ONE_IO, 1,
      :H5FD_MPIO_CHUNK_MULTI_IO, 2
    ]

    typedef :H5FD_mpio_chunk_opt_t, :H5FD_mpio_chunk_opt_t

    enum :H5FD_mpio_collective_opt_t, [
      :H5FD_MPIO_COLLECTIVE_IO, 0,
      :H5FD_MPIO_INDIVIDUAL_IO, 1
    ]

    typedef :H5FD_mpio_collective_opt_t, :H5FD_mpio_collective_opt_t

    attach_function 'H5FD_multi_init', [], :hid_t

    attach_function 'H5Pset_fapl_multi', %i[
      hid_t
      pointer
      pointer
      pointer
      pointer
      hbool_t
    ], :herr_t

    attach_function 'H5Pget_fapl_multi', %i[
      hid_t
      pointer
      pointer
      pointer
      pointer
      pointer
    ], :herr_t

    attach_function 'H5Pset_fapl_split', %i[
      hid_t
      string
      hid_t
      string
      hid_t
    ], :herr_t

    enum :H5FD_onion_target_file_constant_t, [
      :H5FD_ONION_STORE_TARGET_ONION, 0
    ]

    typedef :H5FD_onion_target_file_constant_t, :H5FD_onion_target_file_constant_t

    class H5FDOnionFaplInfoT < ::FFI::Struct
      layout \
        :version, :uint8_t,
        :backing_fapl_id, :hid_t,
        :page_size, :uint32_t,
        :store_target, :H5FD_onion_target_file_constant_t,
        :revision_num, :uint64_t,
        :force_write_open, :uint8_t,
        :creation_flags, :uint8_t,
        :comment, [:char, 256]
    end

    # H5FDOnionFaplInfoT = H5FDOnionFaplInfoT

    attach_function 'H5FD_onion_init', [], :hid_t

    attach_function 'H5Pget_fapl_onion', [
      :hid_t,
      H5FDOnionFaplInfoT.ptr
    ], :herr_t

    attach_function 'H5Pset_fapl_onion', [
      :hid_t,
      H5FDOnionFaplInfoT.ptr
    ], :herr_t

    attach_function 'H5FDonion_get_revision_count', %i[
      string
      hid_t
      pointer
    ], :herr_t

    attach_function 'H5FD_sec2_init', [], :hid_t

    attach_function 'H5Pset_fapl_sec2', [
      :hid_t
    ], :herr_t

    class H5FDSplitterVfdConfigT < ::FFI::Struct
      layout \
        :magic, :int32_t,
        :version, :uint,
        :rw_fapl_id, :hid_t,
        :wo_fapl_id, :hid_t,
        :wo_path, [:char, 4097],
        :log_file_path, [:char, 4097],
        :ignore_wo_errs, :hbool_t
    end

    # H5FDSplitterVfdConfigT = H5FDSplitterVfdConfigT

    attach_function 'H5FD_splitter_init', [], :hid_t

    attach_function 'H5Pset_fapl_splitter', [
      :hid_t,
      H5FDSplitterVfdConfigT.ptr
    ], :herr_t

    attach_function 'H5Pget_fapl_splitter', [
      :hid_t,
      H5FDSplitterVfdConfigT.ptr
    ], :herr_t

    attach_function 'H5FD_stdio_init', [], :hid_t

    attach_function 'H5Pset_fapl_stdio', [
      :hid_t
    ], :herr_t

    class H5VLPassThroughInfoT < ::FFI::Struct
      layout \
        :under_vol_id, :hid_t,
        :under_vol_info, :pointer
    end

    # H5VLPassThroughInfoT = H5VLPassThroughInfoT

    attach_function 'H5VL_pass_through_register', [], :hid_t

    # These variables are defined manually because c2ffi can't parse them

    attach_variable :H5T_NATIVE_SCHAR, :H5T_NATIVE_SCHAR_g, :hid_t
    attach_variable :H5T_NATIVE_UCHAR, :H5T_NATIVE_UCHAR_g, :hid_t
    attach_variable :H5T_NATIVE_SHORT, :H5T_NATIVE_SHORT_g, :hid_t
    attach_variable :H5T_NATIVE_USHORT, :H5T_NATIVE_USHORT_g, :hid_t
    attach_variable :H5T_NATIVE_INT, :H5T_NATIVE_INT_g, :hid_t
    attach_variable :H5T_NATIVE_UINT, :H5T_NATIVE_UINT_g, :hid_t
    attach_variable :H5T_NATIVE_LONG, :H5T_NATIVE_LONG_g, :hid_t
    attach_variable :H5T_NATIVE_ULONG, :H5T_NATIVE_ULONG_g, :hid_t
    attach_variable :H5T_NATIVE_LLONG, :H5T_NATIVE_LLONG_g, :hid_t
    attach_variable :H5T_NATIVE_ULLONG, :H5T_NATIVE_ULLONG_g, :hid_t
    attach_variable :H5T_NATIVE_FLOAT, :H5T_NATIVE_FLOAT_g, :hid_t
    attach_variable :H5T_NATIVE_DOUBLE, :H5T_NATIVE_DOUBLE_g, :hid_t
    attach_variable :H5T_NATIVE_LDOUBLE, :H5T_NATIVE_LDOUBLE_g, :hid_t
    attach_variable :H5T_NATIVE_HADDR, :H5T_NATIVE_HADDR_g, :hid_t
    attach_variable :H5T_NATIVE_HSIZE, :H5T_NATIVE_HSIZE_g, :hid_t
    attach_variable :H5T_NATIVE_HSSIZE, :H5T_NATIVE_HSSIZE_g, :hid_t
    attach_variable :H5T_NATIVE_HERR, :H5T_NATIVE_HERR_g, :hid_t
    attach_variable :H5T_NATIVE_HBOOL, :H5T_NATIVE_HBOOL_g, :hid_t
    attach_variable :H5T_C_S1, :H5T_C_S1_g, :hid_t

    SIZE_MAX = (1 << (::FFI::MemoryPointer.new(:size_t).size * 8)) - 1
    H5T_VARIABLE = SIZE_MAX
  end
end
