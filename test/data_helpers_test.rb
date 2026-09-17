# frozen_string_literal: true

require_relative 'test_helper'

class DataHelpersTest < Test::Unit::TestCase
  test 'normalizes rectangular integer arrays' do
    assert_equal([[1, 2], [3, 4]], HDF5::DataHelpers.normalize_data([[1, 2], [3, 4]]).to_a)
  end

  test 'infers uint64 for the largest unsigned integer' do
    value = HDF5::DataHelpers.normalize_data([(1 << 64) - 1])
    assert_equal(:uint64, HDF5::DType.for_numo(value).to_sym)
  end

  {
    below_int64: [-(1 << 63) - 1], above_uint64: [1 << 64],
    mixed_signed_unsigned: [-1, 1 << 63], nested_overflow: [[1 << 64]]
  }.each do |name, data|
    test "rejects #{name} before Numo conversion" do
      assert_raise(HDF5::ConversionError) { HDF5::DataHelpers.normalize_data(data) }
    end
  end

  test 'rejects ragged arrays' do
    assert_raise(HDF5::ShapeError) { HDF5::DataHelpers.normalize_data([[1.0], [2.0, 3.0]]) }
  end

  test 'preserves nonfinite floats' do
    values = HDF5::DataHelpers.normalize_data([Float::NAN, Float::INFINITY, -Float::INFINITY]).to_a
    assert_true(values.first.nan?)
    assert_equal([Float::INFINITY, -Float::INFINITY], values[1..])
  end

  test 'rejects nil in numeric arrays' do
    dtype = HDF5::DType.for_symbol(:int8)
    assert_raise(HDF5::ConversionError) { HDF5::DataHelpers.normalize_data([1, nil], dtype:) }
  end

  test 'safe widening preserves the source array when native conversion is allowed' do
    source = Numo::Int32[1, 2, 3]
    target = HDF5::DType.for_symbol(:int64)
    assert_same(source, HDF5::DataHelpers.normalize_data(source, dtype: target, convert: false))
  end

  test 'unsafe narrowing converts the source array before native I/O' do
    source = Numo::Int32[1, 2, 3]
    target = HDF5::DType.for_symbol(:int8)
    result = HDF5::DataHelpers.normalize_data(source, dtype: target, casting: :unsafe, convert: false)
    assert_kind_of(Numo::Int8, result)
    assert_equal(source.to_a, result.to_a)
  end

  test 'rejects implicit bool to integer conversion' do
    target = HDF5::DType.for_symbol(:int64)
    assert_raise(HDF5::ConversionError) do
      HDF5::DataHelpers.normalize_data(Numo::Bit[1, 0], dtype: target, convert: false)
    end
  end
end
