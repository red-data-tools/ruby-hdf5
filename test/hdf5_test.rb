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
    assert_equal(10, minor.read_int)
    assert_kind_of(Integer, release.read_int)
  end
end
