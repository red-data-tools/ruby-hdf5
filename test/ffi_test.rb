# frozen_string_literal: true

require_relative 'test_helper'

class FfiTest < Test::Unit::TestCase
  test 'VERSION' do
    assert do
      ::HDF5.const_defined?(:VERSION)
    end
  end

  test 'libversion' do
    major = FFI::MemoryPointer.new(:uint)
    minor = FFI::MemoryPointer.new(:uint)
    release = FFI::MemoryPointer.new(:uint)
    HDF5::FFI.H5get_libversion(major, minor, release)
    assert_include([1, 2], major.read_uint)
    assert_kind_of(Integer, minor.read_uint)
    assert_kind_of(Integer, release.read_uint)
  end

  test 'selects the FFI backend by HDF5 version' do
    assert_equal('ffi_10', HDF5::FFI.send(:backend_for_version, 1, 10, 0))
    assert_equal('ffi_10', HDF5::FFI.send(:backend_for_version, 1, 13, 9))
    assert_equal('ffi_14', HDF5::FFI.send(:backend_for_version, 1, 14, 0))
    assert_equal('ffi_20', HDF5::FFI.send(:backend_for_version, 2, 0, 0))
    assert_equal('ffi_20', HDF5::FFI.send(:backend_for_version, 2, 2, 0))
    assert_raise(HDF5::UnsupportedFeatureError) { HDF5::FFI.send(:backend_for_version, 1, 15, 0) }
    assert_raise(HDF5::UnsupportedFeatureError) { HDF5::FFI.send(:backend_for_version, 2, 3, 0) }
    assert_raise(HDF5::UnsupportedFeatureError) { HDF5::FFI.send(:backend_for_version, 3, 0, 0) }

    error = assert_raise(HDF5::UnsupportedFeatureError) do
      HDF5::FFI.send(:backend_for_version, 1, 9, 9)
    end
    assert_equal('Unsupported HDF5 version 1.9.9', error.message)
  end

  test 'generated FFI backends attach only HDF5 functions' do
    backends = Dir[File.expand_path('../lib/hdf5/ffi_*.rb', __dir__)].sort

    backends.each do |backend|
      functions = File.foreach(backend).filter_map do |line|
        line[/^    attach_function '([^']+)'/, 1]
      end

      assert_equal([], functions.reject { |name| name.start_with?('H5') }, backend)
    end
  end
end
