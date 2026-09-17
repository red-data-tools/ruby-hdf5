# frozen_string_literal: true

require_relative 'test_helper'

class HierarchyTest < Test::Unit::TestCase
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

  test 'manages links through common file and group operations' do
    with_file do |file|
      group = file.create_group('parent')
      group.create_dataset('original', [1])
      assert_equal(['original'], group.keys)
      assert_true(group.key?('original'))
      group.move('original', 'renamed')
      assert_false(group.key?('original'))
      assert_equal(Numo::Int64[1], group['renamed'].read)
      group.create_hard_link('renamed', 'hard-copy')
      group.create_soft_link('/parent/renamed', 'soft-copy')
      group.create_soft_link('/missing', 'broken')
      assert_equal({ type: :hard }, group.link_info('hard-copy'))
      assert_equal({ type: :soft, target: '/parent/renamed' }, group.link_info('soft-copy'))
      assert_equal({ type: :soft, target: '/missing' }, group.link_info('broken'))
      assert_true(group.key?('broken'))
      assert_equal(Numo::Int64[1], group['soft-copy'].read)
      group.delete('renamed').delete('hard-copy').delete('soft-copy').delete('broken')
      assert_false(group.key?('renamed'))
    end
  end

  test 'provides common hierarchy and dataset convenience APIs' do
    with_file do |file|
      group = file.require_group('measurements/nested')
      dataset = group.create_dataset('values', Numo::Int16[[1, 2], [3, 4]])
      assert_equal(2, dataset.ndim)
      assert_equal(4, dataset.size)
      assert_equal([[1, 2], [3, 4]], dataset.read_array)
      assert_equal([1, 2, 3, 4], dataset.read_array(flatten: true))
      assert_equal(['measurements'], file.each_key.to_a)
      group.open_dataset('values') { |opened| assert_equal(dataset.read, opened.read) }
    end
  end

  %i[file group].each do |owner|
    test "#{owner} lookup checks object information before using it" do
      with_file do |file|
        parent = owner == :file ? file : file.create_group('parent')
        function = HDF5::FFI::MiV == 10 ? :H5Oget_info_by_name : :H5Oget_info_by_name1
        calls = 0
        replace_ffi_method(function, ->(*) { calls += 1; -1 }) do
          assert_raise(HDF5::NativeError) { parent['missing'] }
        end
        assert_equal(1, calls)
      end
    end

    test "#{owner} lookup distinguishes unsupported object types from native failures" do
      with_file do |file|
        parent = owner == :file ? file : file.create_group('parent')
        function = HDF5::FFI::MiV == 10 ? :H5Oget_info_by_name : :H5Oget_info_by_name1
        replacement = lambda do |_, _, info, _|
          info[:type] = :H5O_TYPE_NAMED_DATATYPE
          0
        end
        replace_ffi_method(function, replacement) do
          assert_raise(HDF5::UnsupportedTypeError) { parent['type'] }
        end
      end
    end
  end

  test 'open_dataset closes a group handle when rejecting its object type' do
    with_file do |file|
      file.create_group('group')
      close = HDF5::FFI.method(:H5Gclose).super_method
      closed = []
      replace_ffi_method(:H5Gclose, ->(id) { closed << id; close.call(id) }) do
        assert_raise(HDF5::UnsupportedTypeError) { file.open_dataset('group') }
      end
      assert_equal(1, closed.length)
      assert_true(file.key?('group'))
    end
  end

  {
    open_dataset: [:H5Gclose, ->(file) { file.create_group('object') }],
    require_group: [:H5Dclose, ->(file) { file.create_dataset('object', [1]) }]
  }.each do |operation, (function, create_object)|
    test "#{operation} preserves the type error when cleanup fails" do
      with_file do |file|
        create_object.call(file)
        attempts = 0
        replace_ffi_method(function, ->(*) { attempts += 1; -1 }) do
          assert_raise(HDF5::UnsupportedTypeError) { file.public_send(operation, 'object') }
        end
        assert_equal(1, attempts)
        assert_true(file.key?('object'))
      end
    end
  end
end
