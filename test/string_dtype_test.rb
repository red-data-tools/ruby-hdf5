# frozen_string_literal: true

require_relative 'test_helper'

class StringDtypeTest < Test::Unit::TestCase
  test 'round trips a UTF-8 string dataset' do
    with_file do |file|
      dataset = file.create_dataset('greeting', 'hello, world')
      assert_equal('hello, world', dataset.read)
      dataset.write('Ruby HDF5')
      assert_equal('Ruby HDF5', dataset.read)
    end
  end

  test 'reads and writes multidimensional UTF-8 string datasets' do
    with_file do |file|
      strings = [%w[alpha 日本語], %w[gamma delta]]
      dataset = file.create_dataset('labels', strings)
      assert_equal([2, 2], dataset.shape)
      assert_equal(strings, dataset.read.to_a)
      dataset[1, true] = Numo::RObject['epsilon', 'zeta']
      assert_equal([%w[alpha 日本語], %w[epsilon zeta]], dataset.read.to_a)
    end
  end

  test 'reads and modifies multidimensional UTF-8 string attributes' do
    with_file do |file|
      strings = [%w[alpha 日本語], %w[gamma delta]]
      file.attrs['names'] = strings
      assert_equal(strings, file.attrs['names'].to_a)
      file.attrs.modify('names', [%w[one two], %w[three four]])
      assert_equal([%w[one two], %w[three four]], file.attrs['names'].to_a)
    end
  end

  test 'round trips a UTF-8 string attribute' do
    with_file do |file|
      dataset = file.create_dataset('values', [1])
      dataset.attrs['label'] = 'measurement'
      assert_equal('measurement', dataset.attrs['label'])
    end
  end

  test 'reports failure to reclaim variable-length string memory' do
    Dir.mktmpdir do |dir|
      path = File.join(dir, 'string-reclaim.h5')

      HDF5::File.create(path) { |file| file.create_dataset('labels', %w[one two]) }
      HDF5::File.open(path) do |file|
        reclaim = HDF5::FFI.method(:H5Dvlen_reclaim).super_method
        replace_ffi_method(:H5Dvlen_reclaim, ->(*args) { reclaim.call(*args); -1 }) do
          assert_raise(HDF5::NativeError) { file['labels'].read }
        end
      end
    end
  end

  test 'Null strings can be copied from a dataset dtype' do
    with_file do |file|
      dataset = file.create_dataset('text', 'hello')
      empty_string = HDF5::Empty.new(dataset.dtype)
      assert_kind_of(HDF5::Empty, file.create_dataset('null_copy', empty_string).read)
      file.attrs['text'] = 'preserved'
      file.attrs['text'] = empty_string
      assert_kind_of(HDF5::Empty, file.attrs['text'])
    end
  end

  test 'string datasets reject fillvalue inspection' do
    with_file do |file|
      dataset = file.create_dataset('text', 'hello')
      assert_raise(HDF5::UnsupportedFeatureError) { dataset.fillvalue }
      assert_equal('hello', dataset.read)
    end
  end

  test 'invalid UTF-8 input does not replace existing dataset or attribute data' do
    with_file do |file|
      bad = "\xff".b.force_encoding(Encoding::UTF_8)
      assert_raise(HDF5::ConversionError) { file.create_dataset('bad', bad) }
      assert_false(file.key?('bad'))
      dataset = file.create_dataset('text', 'valid')
      assert_raise(HDF5::ConversionError) { dataset.write(bad) }
      assert_equal('valid', dataset.read)
      dataset.attrs['text'] = 'valid'
      assert_raise(HDF5::ConversionError) { dataset.attrs['text'] = bad }
      assert_raise(HDF5::ConversionError) { dataset.attrs.modify('text', bad) }
      assert_equal('valid', dataset.attrs['text'])
      assert_equal(:string, dataset.dtype.to_sym)
      assert_equal(Encoding::UTF_8, dataset.dtype.encoding)
    end
  end

  test 'ASCII declarations are honored on reading and writing existing strings' do
    with_file do |file|
      type_id = HDF5::StringCodec.datatype_id
      space_id = HDF5::FFI.H5Screate(:H5S_SCALAR)
      HDF5::FFI.H5Tset_cset(type_id, 0)
      dataset_id = HDF5::FFI.H5Dcreate2(file.instance_variable_get(:@file_id), 'ascii', type_id, space_id, 0, 0, 0)
      HDF5::FFI.H5Dclose(dataset_id)
      dataset = file['ascii']
      dataset.write('hello')
      assert_equal(Encoding::US_ASCII, dataset.read.encoding)
      assert_equal(Encoding::US_ASCII, dataset.dtype.encoding)
      assert_raise(HDF5::ConversionError) { dataset.write('日本語') }
      assert_equal('hello', dataset.read)

      attr_id = HDF5::FFI.H5Acreate2(file.instance_variable_get(:@file_id), 'ascii', type_id, space_id, 0, 0)
      buffer, pointers = HDF5::StringCodec.buffer_for_values(['hello'])
      HDF5::FFI.H5Awrite(attr_id, type_id, buffer)
      assert_equal(1, pointers.length)
      HDF5::FFI.H5Aclose(attr_id)
      assert_raise(HDF5::ConversionError) { file.attrs.modify('ascii', '日本語') }
      assert_equal('hello', file.attrs['ascii'])

      # HDF5 itself accepts invalid bytes; the text reader must reject them.
      dataset_id = dataset.instance_variable_get(:@dataset_id)
      buffer, pointers = HDF5::StringCodec.buffer_for_values(['日本語'])
      HDF5::FFI.H5Dwrite(dataset_id, type_id, 0, 0, 0, buffer)
      assert_equal(1, pointers.length)
      assert_raise(HDF5::ConversionError) { dataset.read }
    ensure
      HDF5::FFI.H5Sclose(space_id) if space_id
      HDF5::FFI.H5Tclose(type_id) if type_id
    end
  end

  [false, true].each do |read_fails|
    test "reclaim failure closes temporary dataspaces when read_fails=#{read_fails}" do
      with_file do |file|
        dataset = file.create_dataset('strings', %w[one two])
        get_space = HDF5::FFI.method(:H5Dget_space).super_method
        create_space = HDF5::FFI.method(:H5Screate_simple).super_method
        close_space = HDF5::FFI.method(:H5Sclose).super_method
        reclaim = HDF5::FFI.method(:H5Dvlen_reclaim).super_method
        spaces = []
        replace_ffi_method(:H5Dget_space, ->(*args) { get_space.call(*args).tap { |id| spaces << id } }) do
          replace_ffi_method(:H5Screate_simple, ->(*args) { create_space.call(*args).tap { |id| spaces << id } }) do
            replace_ffi_method(:H5Sclose, ->(id) { spaces.delete(id); close_space.call(id) }) do
              replace_ffi_method(:H5Dvlen_reclaim, ->(*args) { reclaim.call(*args); -1 }) do
                unless read_fails
                  assert_raise(HDF5::NativeError) { dataset.read }
                  assert_empty(spaces)
                  next
                end
                original_read = HDF5::FFI.method(:H5Dread).super_method
                replace_ffi_method(:H5Dread, ->(*args) { original_read.call(*args); -1 }) do
                  error = assert_raise(HDF5::NativeError) { dataset.read }
                  assert_equal('Failed to read string dataset', error.message)
                  assert_empty(spaces)
                end
              end
            end
          end
        end
      end
    end
  end

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

  { scalar: '日本語', matrix: [%w[alpha 日本語], %w[gamma delta]] }.each do |name, value|
    test "explicit string datasets preserve #{name} return types" do
      with_file do |file|
        actual = file.create_dataset('values', value, dtype: :string).read
        expected = value.is_a?(Array) ? Numo::RObject.cast(value) : value
        assert_equal(expected, actual)
      end
    end

    test "explicit string attributes preserve #{name} return types" do
      with_file do |file|
        file.attrs.create('values', value, dtype: :string)
        expected = value.is_a?(Array) ? Numo::RObject.cast(value) : value
        assert_equal(expected, file.attrs['values'])
      end
    end
  end

  test 'explicit string datasets accept RObject input and selected writes' do
    with_file do |file|
      objects = Numo::RObject.cast([%w[alpha 日本語], %w[gamma delta]])
      dataset = file.create_dataset('objects', objects, dtype: :string)
      dataset[1, true] = %w[updated labels]
      assert_equal(%w[updated labels], dataset[1, true].to_a)
      assert_equal(objects[0, true], dataset[0, true])
    end
  end

  {
    vector: [[], [0]], matrix: [[[], []], [2, 0]], objects: [Numo::RObject.new(0, 3), [0, 3]]
  }.each do |name, (value, shape)|
    test "empty string #{name} datasets preserve shapes and accept empty writes" do
      with_file do |file|
        dataset = file.create_dataset('empty', value, dtype: :string)
        assert_equal(shape, dataset.shape)
        assert_kind_of(Numo::RObject, dataset.read)
        assert_equal(shape, dataset.read.shape)
        assert_same(value, dataset.write(value))
      end
    end
  end

  test 'string datasets can be allocated with an empty shape' do
    with_file do |file|
      dataset = file.create_dataset('allocated', shape: [0, 3], dtype: :string)
      assert_equal([0, 3], dataset.read.shape)
    end
  end

  test 'string scalar datasets can be allocated and then filled' do
    with_file do |file|
      dataset = file.create_dataset('scalar', shape: [], dtype: :string)
      dataset.write('filled')
      assert_equal('filled', dataset.read)
    end
  end

  test 'extendible string datasets accept writes after resizing' do
    with_file do |file|
      dataset = file.create_dataset('values', shape: [0], dtype: :string, maxshape: [nil], chunks: [4])
      dataset.resize([2])
      dataset.write(%w[first second])
      assert_equal(%w[first second], dataset.read.to_a)
      assert_equal([0], dataset.read(selection: [2...2]).shape)
      assert_equal([], dataset.write([], selection: [2...2]))
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
      assert_raise(HDF5::UnsupportedFeatureError) { file.create_dataset('bad_chunks', missing, compression: :gzip) }
      assert_raise(HDF5::ShapeError) { dataset.write([]) }
      assert_raise(HDF5::ShapeError) { dataset.read(selection: [true]) }
    end
  end

  {
    numeric_scalar: 1, numeric_array: [1], mixed_array: ['ok', 1],
    invalid_encoding: ["\xff".b.force_encoding(Encoding::UTF_8)], nul_byte: ["nul\0"]
  }.each do |name, value|
    test "invalid string #{name} does not create a dataset" do
      with_file do |file|
        assert_raise(HDF5::ConversionError) { file.create_dataset('invalid', value, dtype: :string) }
        assert_false(file.key?('invalid'))
      end
    end

    test "invalid string #{name} does not replace an attribute" do
      with_file do |file|
        file.attrs['existing'] = 'original'
        assert_raise(HDF5::ConversionError) { file.attrs.write('existing', value, dtype: :string) }
        assert_equal('original', file.attrs['existing'])
        assert_equal(['existing'], file.attrs.keys)
      end
    end
  end

  {
    ragged: [HDF5::ShapeError, [['a'], []], { dtype: :string }],
    shape_mismatch: [HDF5::ShapeError, [], { shape: [1], dtype: :string }],
    numeric_dtype: [HDF5::ConversionError, 'a', { dtype: :int8 }],
    inferred_empty: [HDF5::ConversionError, [], {}]
  }.each do |name, (error, value, options)|
    test "rejects string dataset #{name} without creating a link" do
      with_file do |file|
        assert_raise(error) { file.create_dataset('invalid', value, **options) }
        assert_false(file.key?('invalid'))
      end
    end
  end

  test 'empty attributes require an explicit dtype' do
    with_file do |file|
      assert_raise(HDF5::ConversionError) { file.attrs['inferred'] = [] }
      assert_empty(file.attrs.keys)
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
            assert_raise(HDF5::NativeError) { file.create_dataset('failed', ['a'], dtype: :string) }
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
        assert_raise(HDF5::NativeError) { file.attrs.write('existing', ['replacement'], dtype: :string) }
        assert_raise(HDF5::NativeError) { file.attrs.create('new', ['a'], dtype: :string) }
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
                assert_raise(HDF5::NativeError) { file.attrs['existing'] = HDF5::Empty.new(:string) }
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
        assert_raise(HDF5::NativeError) { file.attrs.write('existing', ['replacement'], dtype: :string) }
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
end
