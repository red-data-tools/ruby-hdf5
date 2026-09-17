# frozen_string_literal: true

require_relative 'test_helper'
require 'tmpdir'

class StringDtypeTest < Test::Unit::TestCase
  test 'string dtype describes UTF-8 without retaining a native datatype' do
    dtype = HDF5::DType.for_symbol(:string)
    assert_equal(:string, dtype.to_sym)
    assert_equal(:string, dtype.kind)
    assert_equal(Numo::RObject, dtype.numo_class)
    assert_equal(Encoding::UTF_8, dtype.encoding)
    assert_equal(:H5T_STRING, dtype.hdf5_class)
    assert_equal(:none, dtype.byteorder)
    assert_equal(::FFI.type_size(:pointer), dtype.itemsize)
  end

  test 'explicit strings preserve scalar array and RObject return types' do
    with_file do |file|
      assert_equal('日本語', file.create_dataset('scalar', '日本語', dtype: :string).read)
      matrix = [%w[alpha 日本語], %w[gamma delta]]
      assert_equal(Numo::RObject.cast(matrix), file.create_dataset('matrix', matrix, dtype: :string).read)
      objects = Numo::RObject.cast(matrix)
      dataset = file.create_dataset('objects', objects, dtype: :string)
      dataset[1, true] = %w[updated labels]
      assert_equal(%w[updated labels], dataset[1, true].to_a)
      file.attrs.create('scalar', '日本語', dtype: :string)
      file.attrs.write('matrix', matrix, dtype: :string)
      assert_equal('日本語', file.attrs['scalar'])
      assert_equal(Numo::RObject.cast(matrix), file.attrs['matrix'])
    end
  end

  test 'empty string datasets preserve their shapes and accept empty writes' do
    with_file do |file|
      cases = { vector: [[], [0]], matrix: [[[], []], [2, 0]], objects: [Numo::RObject.new(0, 3), [0, 3]] }
      cases.each do |name, (data, shape)|
        dataset = file.create_dataset(name.to_s, data, dtype: :string)
        assert_equal(shape, dataset.shape)
        assert_kind_of(Numo::RObject, dataset.read)
        assert_equal(shape, dataset.read.shape)
        assert_same(data, dataset.write(data))
      end
      allocated = file.create_dataset('allocated', shape: [0, 3], dtype: :string)
      assert_equal([0, 3], allocated.read.shape)
      scalar = file.create_dataset('allocated_scalar', shape: [], dtype: :string)
      scalar.write('filled')
      assert_equal('filled', scalar.read)
      extendible = file.create_dataset('extendible', shape: [0], dtype: :string, maxshape: [nil], chunks: [4])
      extendible.resize([2])
      extendible.write(%w[first second])
      assert_equal(%w[first second], extendible.read.to_a)
      assert_equal([0], extendible.read(selection: [2...2]).shape)
      assert_equal([], extendible.write([], selection: [2...2]))
    end
  end

  test 'empty string attributes can be created replaced and modified' do
    with_file do |file|
      file.attrs.create('vector', [], dtype: :string)
      file.attrs.write('matrix', [[], []], dtype: :string)
      file.attrs.write('objects', Numo::RObject.new(0, 3), dtype: :string)
      assert_equal([0], file.attrs['vector'].shape)
      assert_equal([2, 0], file.attrs['matrix'].shape)
      assert_equal([0, 3], file.attrs['objects'].shape)
      file.attrs.modify('matrix', [[], []])
      file.attrs['replaced'] = 'old'
      file.attrs.write('replaced', [], dtype: :string)
      assert_equal([0], file.attrs['replaced'].shape)
      assert_equal(%w[matrix objects replaced vector], file.attrs.keys.sort)
    end
  end

  test 'Null string datasets and attributes round trip and reject shape and dtype conflicts' do
    with_file do |file|
      missing = HDF5::Empty.new(:string)
      dataset = file.create_dataset('missing', missing)
      assert_nil(dataset.shape)
      assert_equal(0, dataset.size)
      assert_equal(:string, dataset.read.dtype.to_sym)
      assert_equal(Encoding::UTF_8, dataset.read.dtype.encoding)
      assert_kind_of(HDF5::Empty, dataset.read(dtype: :string))
      file.attrs['missing'] = missing
      assert_equal(:string, file.attrs['missing'].dtype.to_sym)
      assert_same(missing, file.attrs.modify('missing', missing))
      assert_raise(HDF5::ShapeError) { file.create_dataset('bad_shape', missing, shape: [0]) }
      assert_raise(HDF5::ConversionError) { file.create_dataset('bad_dtype', missing, dtype: :int8) }
      assert_raise(HDF5::ConversionError) { file.attrs.write('bad_dtype', missing, dtype: :int8) }
      assert_raise(HDF5::Error) { file.create_dataset('bad_chunks', missing, compression: :gzip) }
      assert_raise(HDF5::Error) { dataset.write([]) }
      assert_raise(HDF5::Error) { dataset.read(selection: [true]) }
    end
  end

  test 'invalid string inputs are rejected without changing existing objects' do
    with_file do |file|
      file.create_dataset('existing', 'original')
      file.attrs['existing'] = 'original'
      [1, [1], ['ok', 1], ["\xff".b.force_encoding(Encoding::UTF_8)], ["nul\0"]].each do |data|
        assert_raise_kind_of(HDF5::Error) { file.create_dataset('invalid', data, dtype: :string) }
        assert_false(file.key?('invalid'))
        assert_raise_kind_of(HDF5::Error) { file.attrs.write('existing', data, dtype: :string) }
        assert_equal('original', file.attrs['existing'])
      end
      assert_raise(HDF5::ShapeError) { file.create_dataset('ragged', [['a'], []], dtype: :string) }
      assert_raise(HDF5::ShapeError) { file.create_dataset('shape', [], shape: [1], dtype: :string) }
      assert_raise(HDF5::ConversionError) { file.create_dataset('numeric', 'a', dtype: :int8) }
      assert_raise(HDF5::Error) { file.create_dataset('inferred', []) }
      assert_raise(HDF5::Error) { file.attrs['inferred'] = [] }
      assert_equal('original', file['existing'].read)
      assert_equal(['existing'], file.keys)
      assert_equal(['existing'], file.attrs.keys)
    end
  end

  test 'native dataset creation write failure removes the new link and closes owned string types' do
    with_file do |file|
      copied = []
      closed = []
      copy = HDF5::FFI.method(:H5Tcopy).super_method
      close = HDF5::FFI.method(:H5Tclose).super_method
      replace_ffi_method(:H5Tcopy, ->(*args) { copy.call(*args).tap { |id| copied << id } }) do
        replace_ffi_method(:H5Tclose, ->(id) { closed << id; close.call(id) }) do
          replace_ffi_method(:H5Dwrite, ->(*) { -1 }) do
            assert_raise(HDF5::Error) { file.create_dataset('failed', ['a'], dtype: :string) }
          end
          file.create_dataset('empty', [], dtype: :string)
          file.create_dataset('null', HDF5::Empty.new(:string))
        end
      end
      assert_false(file.key?('failed'))
      assert_equal(3, copied.length)
      copied.each { |id| assert_include(closed, id) }
      assert_equal(3, file.instance_variable_get(:@context).instance_variable_get(:@handles).length)
    end
  end

  test 'native attribute write failure preserves old values and removes new or temporary attributes' do
    with_file do |file|
      file.attrs['existing'] = 'original'
      before = file.attrs.keys
      replace_ffi_method(:H5Awrite, ->(*) { -1 }) do
        assert_raise(HDF5::Error) { file.attrs.write('existing', ['replacement'], dtype: :string) }
        assert_raise(HDF5::Error) { file.attrs.create('new', ['a'], dtype: :string) }
      end
      assert_equal('original', file.attrs['existing'])
      assert_equal(before, file.attrs.keys)
    end
  end

  test 'native attribute creation failure closes owned types and dataspaces' do
    with_file do |file|
      file.attrs['existing'] = 'original'
      copied = []
      closed_types = []
      spaces = []
      closed_spaces = []
      copy = HDF5::FFI.method(:H5Tcopy).super_method
      close_type = HDF5::FFI.method(:H5Tclose).super_method
      create_space = HDF5::FFI.method(:H5Screate).super_method
      close_space = HDF5::FFI.method(:H5Sclose).super_method
      replace_ffi_method(:H5Tcopy, ->(*args) { copy.call(*args).tap { |id| copied << id } }) do
        replace_ffi_method(:H5Tclose, ->(id) { closed_types << id; close_type.call(id) }) do
          replace_ffi_method(:H5Screate, ->(*args) { create_space.call(*args).tap { |id| spaces << id } }) do
            replace_ffi_method(:H5Sclose, ->(id) { closed_spaces << id; close_space.call(id) }) do
              replace_ffi_method(:H5Acreate2, ->(*) { -1 }) do
                assert_raise(HDF5::Error) { file.attrs['existing'] = HDF5::Empty.new(:string) }
              end
            end
          end
        end
      end
      assert_equal(1, copied.length)
      assert_equal(copied, closed_types)
      assert_equal(spaces, closed_spaces)
      assert_equal('original', file.attrs['existing'])
      assert_equal(['existing'], file.attrs.keys)
    end
  end

  test 'zero-sized and Null string values do not perform native data I/O' do
    with_file do |file|
      replace_ffi_method(:H5Dwrite, ->(*) { flunk('Unexpected dataset write') }) do
        replace_ffi_method(:H5Awrite, ->(*) { flunk('Unexpected attribute write') }) do
          file.create_dataset('empty', [], dtype: :string)
          file.create_dataset('null', HDF5::Empty.new(:string))
          file.attrs.create('empty', [], dtype: :string)
          file.attrs['null'] = HDF5::Empty.new(:string)
        end
      end
      replace_ffi_method(:H5Dread, ->(*) { flunk('Unexpected dataset read') }) do
        replace_ffi_method(:H5Aread, ->(*) { flunk('Unexpected attribute read') }) do
          assert_equal([0], file['empty'].read.shape)
          assert_kind_of(HDF5::Empty, file['null'].read)
          assert_equal([0], file.attrs['empty'].shape)
          assert_kind_of(HDF5::Empty, file.attrs['null'])
        end
      end
    end
  end

  test 'attribute replacement rename failure restores the original name' do
    with_file do |file|
      file.attrs['existing'] = 'original'
      rename = HDF5::FFI.method(:H5Arename).super_method
      calls = 0
      replace_ffi_method(:H5Arename, lambda { |*args|
        calls += 1
        calls == 2 ? -1 : rename.call(*args)
      }) do
        assert_raise(HDF5::Error) { file.attrs.write('existing', ['replacement'], dtype: :string) }
      end
      assert_equal('original', file.attrs['existing'])
      assert_equal(['existing'], file.attrs.keys)
    end
  end

  test 'closed files datasets and attribute managers reject string operations' do
    with_file do |file|
      dataset = file.create_dataset('empty', [], dtype: :string)
      attrs = file.attrs
      file.close
      assert_raise(HDF5::ClosedError) { file.create_dataset('other', [], dtype: :string) }
      assert_raise(HDF5::ClosedError) { dataset.write([]) }
      assert_raise(HDF5::ClosedError) { dataset.read }
      assert_raise(HDF5::ClosedError) { attrs.write('other', [], dtype: :string) }
    end
  end

  private

  def with_file
    Dir.mktmpdir do |dir|
      HDF5::File.create(File.join(dir, 'strings.h5')) { |file| yield file }
    end
  end
end
