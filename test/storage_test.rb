# frozen_string_literal: true

require_relative 'test_helper'

class StorageTest < Test::Unit::TestCase
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

  test 'limits automatic chunks to the target byte size' do
    with_file do |file|
      dataset = file.create_dataset('matrix', shape: [1000, 1000], dtype: :float64, chunks: :auto)
      assert_operator(dataset.chunks.inject(8, :*), :<=, 256 * 1024)
      assert_true(dataset.chunks.all?(&:positive?))
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
      end
    end
  end

  test 'resizes and appends to an extendible dataset' do
    with_file do |file|
      dataset = file.create_dataset('matrix', shape: [0, 2], dtype: :int16, maxshape: [nil, 2], chunks: [2, 2])
      assert_equal([nil, 2], dataset.maxshape)
      assert_equal([2, 2], dataset.chunks)
      assert_same(dataset, dataset.append(Numo::Int16[[1, 2], [3, 4]]))
      dataset.append(Numo::Int16[[5, 6]])
      assert_equal([3, 2], dataset.shape)
      assert_equal(Numo::Int16[[1, 2], [3, 4], [5, 6]], dataset.read)
      assert_same(dataset, dataset.append(Numo::Int16.zeros(0, 2)))
      assert_equal([3, 2], dataset.shape)
      assert_raise(HDF5::ConversionError) { dataset.append(Numo::Int64[[7, 8]]) }
      assert_equal([3, 2], dataset.shape)
      assert_raise(HDF5::ShapeError) { dataset.resize([4, 3]) }
    end
  end

  test 'uses the configured fill value for unwritten data' do
    with_file do |file|
      dataset = file.create_dataset('values', shape: [3], dtype: :int16, fillvalue: 7)
      assert_equal(7, dataset.fillvalue)
      assert_equal(Numo::Int16[7, 7, 7], dataset.read)
    end
  end

  test 'supports automatic chunks for variable-length string datasets' do
    with_file do |file|
      dataset = file.create_dataset('labels', %w[one two three], chunks: :auto, compression: :gzip)
      assert_equal(%w[one two three], dataset.read.to_a)
      assert_equal([3], dataset.chunks)
    end
  end

  test 'each_chunk rejects contiguous datasets' do
    with_file do |file|
      dataset = file.create_dataset('contiguous', [1, 2])
      assert_raise(HDF5::UnsupportedFeatureError) { dataset.each_chunk.to_a }
    end
  end

  test 'append restores the original extent when its write fails' do
    with_file do |file|
      dataset = file.create_dataset('values', Numo::Int16[1, 2], maxshape: [nil])
      replace_ffi_method(:H5Dwrite, ->(*) { -1 }) do
        error = assert_raise(HDF5::NativeError) { dataset.append(Numo::Int16[3]) }
        assert_equal('Failed to write dataset', error.message)
      end
      assert_equal([2], dataset.shape)
      assert_equal([1, 2], dataset.read.to_a)
    end
  end

  test 'append reports rollback failure with the original write failure as cause' do
    with_file do |file|
      dataset = file.create_dataset('values', Numo::Int16[1, 2], maxshape: [nil])
      set_extent = HDF5::FFI.method(:H5Dset_extent).super_method
      calls = 0
      replace_ffi_method(:H5Dset_extent, ->(*args) { calls += 1; calls == 1 ? set_extent.call(*args) : -1 }) do
        replace_ffi_method(:H5Dwrite, ->(*) { -1 }) do
          error = assert_raise(HDF5::NativeError) { dataset.append(Numo::Int16[3]) }
          assert_include(error.message, 'extent rollback failed')
          assert_kind_of(HDF5::NativeError, error.cause)
          assert_equal('Failed to write dataset', error.cause.message)
        end
      end
      assert_equal([3], dataset.shape)
    end
  end

  { fractional: 1.5, string: '1', negative: -1, excessive: 10 }.each do |name, level|
    test "rejects #{name} gzip levels before dataset creation" do
      with_file do |file|
        assert_raise(ArgumentError) do
          file.create_dataset('invalid', [1], compression: :gzip, compression_opts: level)
        end
        assert_false(file.key?('invalid'))
      end
    end
  end
end
