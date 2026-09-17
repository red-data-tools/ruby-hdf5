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
    assert_equal(:float64, d.dtype.to_sym)
    assert_equal(Numo::DFloat[1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0, 10.0], d.read)
    d = g['bar_int']
    assert_equal([10], d.shape)
    assert_equal(:int64, d.dtype.to_sym)
    assert_equal(Numo::Int64[1, 2, 3, 4, 5, 6, 7, 8, 9, 10], d.read)
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
      assert_equal(:int64, loaded.dtype.to_sym)
      assert_equal(Numo::Int64[1, 2, 3, 4], loaded.read)
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
      assert_equal(:float64, loaded.dtype.to_sym)
      assert_equal(Numo::DFloat[1.5, 2.5, 3.5], loaded.read)
      loaded.close
      reopened.close
    end
  end

  test 'preserves multidimensional Numo data' do
    Dir.mktmpdir do |dir|
      path = File.join(dir, 'matrix.h5')
      matrix = Numo::SFloat[[1.5, 2.5], [3.5, 4.5]]

      HDF5::File.create(path) do |file|
        file.create_dataset('matrix', matrix)
      end

      HDF5::File.open(path) do |file|
        dataset = file['matrix']
        assert_equal([2, 2], dataset.shape)
        assert_equal(:float32, dataset.dtype.to_sym)
        assert_equal(matrix, dataset.read)
      end
    end
  end

  test 'reads a multidimensional selection' do
    Dir.mktmpdir do |dir|
      path = File.join(dir, 'selection.h5')
      matrix = Numo::Int16[[1, 2, 3], [4, 5, 6], [7, 8, 9]]

      HDF5::File.create(path) { |file| file.create_dataset('matrix', matrix) }

      HDF5::File.open(path) do |file|
        dataset = file['matrix']
        assert_equal(Numo::Int16[[4, 5, 6], [7, 8, 9]], dataset.read(selection: [1.., true]))
        assert_equal(Numo::Int16[2, 5, 8], dataset.read(selection: [true, 1]))
        assert_equal(Numo::Int16[[1, 2, 3], [7, 8, 9]], dataset.read(selection: [HDF5.slice(0..2, step: 2), true]))
        assert_equal(5, dataset.read(selection: [1, 1]))
      end
    end
  end

  test 'writes a multidimensional selection without changing other values' do
    Dir.mktmpdir do |dir|
      path = File.join(dir, 'selection-write.h5')
      matrix = Numo::Int16[[1, 2, 3], [4, 5, 6], [7, 8, 9]]

      HDF5::File.create(path) do |file|
        dataset = file.create_dataset('matrix', matrix)
        dataset[1.., true] = Numo::Int16[[10, 11, 12], [13, 14, 15]]
        dataset[0, 0] = 20
        dataset.write(-1, selection: [0, 1..])
        assert_equal(Numo::Int16[[20, -1, -1], [10, 11, 12], [13, 14, 15]], dataset.read)
        assert_equal(11, dataset[1, 1])
      end
    end
  end

  test 'reads a selection into an existing Numo array' do
    Dir.mktmpdir do |dir|
      path = File.join(dir, 'read-into.h5')
      matrix = Numo::Int16[[1, 2, 3], [4, 5, 6], [7, 8, 9]]

      HDF5::File.create(path) { |file| file.create_dataset('matrix', matrix) }

      HDF5::File.open(path) do |file|
        destination = Numo::Int16.zeros(2, 3)
        assert_same(destination, file['matrix'].read_into(destination, selection: [1.., true]))
        assert_equal(Numo::Int16[[4, 5, 6], [7, 8, 9]], destination)
        assert_raise(HDF5::Error) { file['matrix'].read_into(Numo::Int16.zeros(3)) }
      end
    end
  end

  test 'yields independent blocks within the requested byte budget' do
    Dir.mktmpdir do |dir|
      path = File.join(dir, 'each-block.h5')
      matrix = Numo::Int16[[1, 2, 3, 4], [5, 6, 7, 8], [9, 10, 11, 12]]

      HDF5::File.create(path) { |file| file.create_dataset('matrix', matrix) }

      HDF5::File.open(path) do |file|
        blocks = []
        file['matrix'].each_block(max_bytes: 4) do |selection, block|
          assert_operator(block.to_binary.bytesize, :<=, 4)
          blocks << [selection, block]
        end

        assert_equal(6, blocks.length)
        assert_equal([0...1, 0...2], blocks.first.first)
        assert_equal(Numo::Int16[[1, 2]], blocks.first.last)
        assert_equal(Numo::Int16[[11, 12]], blocks.last.last)
      end
    end
  end

  test 'creates a chunked gzip dataset' do
    Dir.mktmpdir do |dir|
      path = File.join(dir, 'chunked.h5')
      matrix = Numo::Int16[[1, 2, 3], [4, 5, 6], [7, 8, 9]]

      HDF5::File.create(path) do |file|
        dataset = file.create_dataset('matrix', matrix, chunks: [2, 3], compression: :gzip, compression_opts: 1,
                                      shuffle: true, fletcher32: true)
        assert_equal([2, 3], dataset.chunks)
        assert_equal(matrix, dataset.read)
      end
    end
  end

  test 'yields chunked dataset regions including a partial final chunk' do
    Dir.mktmpdir do |dir|
      path = File.join(dir, 'each-chunk.h5')
      matrix = Numo::Int16[[1, 2, 3], [4, 5, 6], [7, 8, 9]]

      HDF5::File.create(path) { |file| file.create_dataset('matrix', matrix, chunks: [2, 2]) }

      HDF5::File.open(path) do |file|
        chunks = file['matrix'].each_chunk.to_a
        assert_equal(4, chunks.length)
        assert_equal([0...2, 0...2], chunks.first.first)
        assert_equal(Numo::Int16[[1, 2], [4, 5]], chunks.first.last)
        assert_equal([2...3, 2...3], chunks.last.first)
        assert_equal(Numo::Int16[[9]], chunks.last.last)
        assert_raise(HDF5::Error) { file.create_dataset('contiguous', matrix).each_chunk.to_a }
      end
    end
  end

  test 'resizes and appends to an extendible dataset' do
    Dir.mktmpdir do |dir|
      path = File.join(dir, 'extendible.h5')

      HDF5::File.create(path) do |file|
        dataset = file.create_dataset('matrix', shape: [0, 2], dtype: :int16, maxshape: [nil, 2], chunks: [2, 2])
        assert_equal([nil, 2], dataset.maxshape)
        assert_equal([2, 2], dataset.chunks)
        assert_same(dataset, dataset.append(Numo::Int16[[1, 2], [3, 4]]))
        dataset.append(Numo::Int16[[5, 6]])
        assert_equal([3, 2], dataset.shape)
        assert_equal(Numo::Int16[[1, 2], [3, 4], [5, 6]], dataset.read)
        assert_raise(HDF5::Error) { dataset.resize([4, 3]) }
      end
    end
  end

  test 'uses the configured fill value for unwritten data' do
    Dir.mktmpdir do |dir|
      path = File.join(dir, 'fillvalue.h5')

      HDF5::File.create(path) do |file|
        dataset = file.create_dataset('values', shape: [3], dtype: :int16, fillvalue: 7)
        assert_equal(7, dataset.fillvalue)
        assert_equal(Numo::Int16[7, 7, 7], dataset.read)
      end
    end
  end

  test 'preserves int64 values on create' do
    Dir.mktmpdir do |dir|
      path = File.join(dir, 'int64-create.h5')

      HDF5::File.create(path) do |file|
        dataset = file.create_dataset('large', [1 << 40])
        assert_equal(Numo::Int64[1 << 40], dataset.read)
      end
    end
  end

  test 'rejects writes with a mismatched shape' do
    Dir.mktmpdir do |dir|
      path = File.join(dir, 'shape-write.h5')

      HDF5::File.create(path) do |file|
        dataset = file.create_dataset('ints', [1, 2, 3])
        assert_raise(HDF5::Error) { dataset.write([1]) }
      end
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
        assert_equal(Numo::Int64[10, 20, 30], file['values']['ints'].read)
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

  test 'dataset attrs overwrite existing value' do
    Dir.mktmpdir do |dir|
      path = File.join(dir, 'attribute-overwrite.h5')

      HDF5::File.create(path) do |file|
        dataset = file.create_dataset('values', [1, 2, 3])
        dataset.attrs['scale'] = 42
        dataset.attrs['scale'] = 100
      end

      HDF5::File.open(path) do |file|
        assert_equal([100], file['values'].attrs['scale'])
      end
    end
  end

  test 'rejects integer values outside native int range on attribute write' do
    min = -(1 << (::FFI.type_size(:int) * 8 - 1))
    max = (1 << (::FFI.type_size(:int) * 8 - 1)) - 1

    Dir.mktmpdir do |dir|
      path = File.join(dir, 'attribute-overflow.h5')

      HDF5::File.create(path) do |file|
        dataset = file.create_dataset('values', [1, 2, 3])
        error = assert_raise(HDF5::Error) do
          dataset.attrs['scale'] = [max + 1]
        end
        assert_include(error.message, "#{min}..#{max}")
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
