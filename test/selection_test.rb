# frozen_string_literal: true

require_relative 'test_helper'

class SelectionTest < Test::Unit::TestCase
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
        assert_raise(HDF5::ShapeError) { file['matrix'].read_into(Numo::Int16.zeros(3)) }
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

  test 'writing an empty selection is a no-op' do
    with_file do |file|
      dataset = file.create_dataset('values', [1, 2, 3])
      empty = Numo::Int64.zeros(0)
      assert_same(empty, dataset.write(empty, selection: [1...1]))
      assert_equal(Numo::Int64[1, 2, 3], dataset.read)
    end
  end

  { excess_indices: [0, 0], out_of_bounds: [3], unsupported: [false],
    fractional_range: [0.5..1.5] }.each do |name, selection|
    test "rejects #{name} with IndexError" do
      assert_raise(IndexError) { HDF5::Selection.normalize(selection, [3]) }
    end
  end

  [0, -1, nil, 1.5].each do |step|
    test "rejects invalid Slice step #{step.inspect}" do
      selection = HDF5::Slice.new(range: 0..2, step:)
      assert_raise(IndexError) { HDF5::Selection.normalize(selection, [3]) }
    end
  end
end
