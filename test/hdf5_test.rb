# frozen_string_literal: true

require_relative 'test_helper'

class HDF5Test < Test::Unit::TestCase
  test 'reads the example fixture hierarchy and values' do
    HDF5::File.open(File.join(__dir__, 'fixtures', 'example.h5')) do |file|
      assert_equal(%w[foo], file.list_entries)
      group = file['foo']
      assert_equal(%w[bar_float bar_int], group.list_datasets)
      floats = group['bar_float']
      assert_equal([10], floats.shape)
      assert_equal(:float64, floats.dtype.to_sym)
      assert_equal(Numo::DFloat[1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0, 10.0], floats.read)
      integers = group['bar_int']
      assert_equal([10], integers.shape)
      assert_equal(:int64, integers.dtype.to_sym)
      assert_equal(Numo::Int64[1, 2, 3, 4, 5, 6, 7, 8, 9, 10], integers.read)
    end
  end
end
