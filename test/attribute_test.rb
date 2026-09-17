# frozen_string_literal: true

require_relative 'test_helper'

class AttributeTest < Test::Unit::TestCase
  test 'dataset attrs reads integer attribute' do
    Dir.mktmpdir do |dir|
      path = File.join(dir, 'attribute.h5')

      HDF5::File.create(path) do |file|
        dataset = file.create_dataset('values', [1, 2, 3])
        dataset.attrs['scale'] = 42
      end

      HDF5::File.open(path) do |file|
        assert_equal(42, file['values'].attrs['scale'])
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
        assert_equal(100, file['values'].attrs['scale'])
      end
    end
  end

  test 'preserves int64 and multidimensional Numo attributes' do
    with_file do |file|
      dataset = file.create_dataset('values', [1, 2, 3])
      dataset.attrs['large'] = 1 << 40
      dataset.attrs['matrix'] = Numo::SFloat[[1.5, 2.5], [3.5, 4.5]]
      assert_equal(1 << 40, dataset.attrs['large'])
      assert_equal(Numo::SFloat[[1.5, 2.5], [3.5, 4.5]], dataset.attrs['matrix'])
    end
  end

  test 'dataset attrs raises HDF5 error for missing attribute' do
    Dir.mktmpdir do |dir|
      path = File.join(dir, 'missing-attribute.h5')

      HDF5::File.create(path) do |file|
        dataset = file.create_dataset('values', [1, 2, 3])
        assert_raise(HDF5::NativeError) do
          dataset.attrs['does-not-exist']
        end
      ensure
        dataset.close if dataset
      end
    end
  end

  test 'manages and modifies attributes without replacing their type' do
    with_file do |file|
      attrs = file.create_dataset('values', [1]).attrs
      attrs.create('scale', Numo::Int16.cast(2))
      assert_equal(['scale'], attrs.keys)
      assert_true(attrs.key?('scale'))
      attrs.modify('scale', 4)
      assert_equal(4, attrs['scale'])
      assert_raise(HDF5::ShapeError) { attrs.modify('scale', [1, 2]) }
      assert_raise(HDF5::Error) { attrs.create('scale', 5) }
      assert_same(attrs, attrs.delete('scale'))
      assert_false(attrs.key?('scale'))
    end
  end

  test 'attribute modify and fill values share safe input checks' do
    with_file do |file|
      dataset = file.create_dataset('values', [1])
      dataset.attrs['small'] = Numo::Int8.cast(7)
      assert_raise(HDF5::ConversionError) { dataset.attrs.modify('small', 300) }
      assert_equal(7, dataset.attrs['small'])
      dataset.attrs.modify('small', 300, casting: :unsafe)
      assert_equal(44, dataset.attrs['small'])
      assert_raise(HDF5::ConversionError) { file.create_dataset('bad_fill', shape: [3], dtype: :int8, fillvalue: 300) }
      assert_false(file.key?('bad_fill'))
      assert_equal([44, 44], file.create_dataset('unsafe_fill', shape: [2], dtype: :int8, fillvalue: 300,
                                                                casting: :unsafe).read.to_a)
    end
  end

  { integers: Numo::Int32[1, 2, 3], complex: Numo::SComplex[1, 2, 3] }.each do |name, values|
    test "modifies complex attributes using #{name}" do
      with_file do |file|
        file.attrs['complex'] = Numo::DComplex[0, 0, 0]
        file.attrs.modify('complex', values)
        assert_equal(Numo::DComplex.cast(values), file.attrs['complex'])
      end
    end
  end

  test 'modifies wider integer attributes using a narrower source datatype' do
    with_file do |file|
      file.attrs['wide'] = Numo::Int64[0, 0, 0]
      file.attrs.modify('wide', Numo::Int32[1, 2, 3])
      assert_equal([1, 2, 3], file.attrs['wide'].to_a)
    end
  end

  test 'Null attributes retain their dtype when copied' do
    with_file do |file|
      file.attrs['null'] = HDF5::Empty.new(:int16)
      value = file.attrs['null']
      assert_kind_of(HDF5::Empty, value)
      assert_equal(:int16, value.dtype.to_sym)
      file.attrs['copy'] = value
      assert_equal(:int16, file.attrs['copy'].dtype.to_sym)
    end
  end

  test 'modifying a Null attribute rejects values and preserves its dtype' do
    with_file do |file|
      file.attrs['null'] = HDF5::Empty.new(:int16)
      assert_raise(HDF5::ShapeError) { file.attrs.modify('null', 0) }
      assert_equal(:int16, file.attrs['null'].dtype.to_sym)
    end
  end

  { string: 'hello', null: HDF5::Empty.new(:int16) }.each do |name, value|
    test "modifying #{name} attributes rejects invalid casting modes" do
      with_file do |file|
        file.attrs['value'] = value
        replace_ffi_method(:H5Awrite, ->(*) { flunk('Invalid casting modes must not perform I/O') }) do
          assert_raise(ArgumentError) { file.attrs.modify('value', value, casting: :invalid) }
        end
      end
    end
  end
end
