# frozen_string_literal: true

require_relative 'test_helper'

class HDF5Test < Test::Unit::TestCase
  test 'VERSION' do
    assert do
      ::HDF5.const_defined?(:VERSION)
    end
  end

  test 'libversion' do
    major = FFI::MemoryPointer.new(:int)
    minor = FFI::MemoryPointer.new(:int)
    release = FFI::MemoryPointer.new(:int)
    HDF5::FFI.H5get_libversion(major, minor, release)
    assert_equal(1, major.read_int)
    assert_kind_of(Integer, minor.read_int)
    assert_kind_of(Integer, release.read_int)
  end

  test 'example' do
    f = HDF5::File.new(File.join(__dir__, 'fixtures', 'example.h5'))
    assert_equal(%w[foo], f.list_entries)
    g = f['foo']
    assert_equal(%w[bar_float bar_int], g.list_datasets)
    d = g['bar_float']
    assert_equal([10], d.shape)
    assert_equal(:H5T_FLOAT, d.dtype)
    assert_equal([1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0, 10.0], d.read)
    d = g['bar_int']
    assert_equal([10], d.shape)
    assert_equal(:H5T_INTEGER, d.dtype)
    assert_equal([1, 2, 3, 4, 5, 6, 7, 8, 9, 10], d.read)
  end
end
