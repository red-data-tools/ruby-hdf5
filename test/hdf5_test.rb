# frozen_string_literal: true

require_relative 'test_helper'
require 'tmpdir'

class HDF5Test < Test::Unit::TestCase
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

  test 'create group and integer dataset' do
    Dir.mktmpdir do |dir|
      path = File.join(dir, 'integer.h5')
      file = HDF5::File.create(path)
      group = file.create_group('numbers')
      dataset = group.create_dataset('ints', [1, 2, 3, 4])
      dataset.close
      group.close
      file.close

      reopened = HDF5::File.open(path)
      assert_equal(%w[numbers], reopened.list_entries)
      loaded = reopened['numbers']['ints']
      assert_equal([4], loaded.shape)
      assert_equal(:H5T_INTEGER, loaded.dtype)
      assert_equal([1, 2, 3, 4], loaded.read)
      loaded.close
      reopened.close
    end
  end

  test 'create float dataset' do
    Dir.mktmpdir do |dir|
      path = File.join(dir, 'float.h5')
      file = HDF5::File.create(path)
      dataset = file.create_dataset('values', [1.5, 2.5, 3.5])
      dataset.close
      file.close

      reopened = HDF5::File.open(path)
      loaded = reopened['values']
      assert_equal([3], loaded.shape)
      assert_equal(:H5T_FLOAT, loaded.dtype)
      assert_equal([1.5, 2.5, 3.5], loaded.read)
      loaded.close
      reopened.close
    end
  end

  test 'block API closes resources automatically' do
    Dir.mktmpdir do |dir|
      path = File.join(dir, 'block.h5')

      HDF5::File.create(path) do |file|
        file.create_group('values') do |group|
          group.create_dataset('ints', [10, 20, 30])
        end
      end

      HDF5::File.open(path) do |file|
        assert_equal([10, 20, 30], file['values']['ints'].read)
      end
    end
  end

  test 'dataset attrs reads integer attribute' do
    Dir.mktmpdir do |dir|
      path = File.join(dir, 'attribute.h5')

      HDF5::File.create(path) do |file|
        dataset = file.create_dataset('values', [1, 2, 3])
        dataset.attrs['scale'] = 42
      end

      HDF5::File.open(path) do |file|
        assert_equal([42], file['values'].attrs['scale'])
      end
    end
  end

  test 'group list_datasets returns only datasets' do
    Dir.mktmpdir do |dir|
      path = File.join(dir, 'group-list.h5')

      HDF5::File.create(path) do |file|
        file.create_group('parent') do |parent|
          parent.create_group('child')
          parent.create_dataset('numbers', [1, 2, 3])
        end
      end

      HDF5::File.open(path) do |file|
        parent = file['parent']
        assert_equal(%w[child numbers].sort, parent.list_entries.sort)
        assert_equal(%w[numbers], parent.list_datasets)
      end
    end
  end

  test 'dataset attrs raises HDF5 error for missing attribute' do
    Dir.mktmpdir do |dir|
      path = File.join(dir, 'missing-attribute.h5')

      HDF5::File.create(path) do |file|
        dataset = file.create_dataset('values', [1, 2, 3])
        assert_raise(HDF5::Error) do
          dataset.attrs['does-not-exist']
        end
      ensure
        dataset.close if dataset
      end
    end
  end

  test 'raises HDF5 error for missing file' do
    assert_raise(HDF5::Error) do
      HDF5::File.open('/tmp/does-not-exist-ruby-hdf5.h5')
    end
  end
end
