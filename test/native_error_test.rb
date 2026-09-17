# frozen_string_literal: true

require_relative 'test_helper'

class NativeErrorTest < Test::Unit::TestCase
  {
    shape_dimensions: [:shape, :H5Sget_simple_extent_dims, -1],
    maximum_rank: [:maxshape, :H5Sget_simple_extent_ndims, -1],
    dataspace_type: [:shape, :H5Sget_simple_extent_type, :H5S_NO_CLASS],
    datatype_class: [:dtype, :H5Tget_class, :H5T_NO_CLASS],
    datatype_size: [:dtype, :H5Tget_size, 0],
    datatype_sign: [:dtype, :H5Tget_sign, :H5T_SGN_ERROR],
    datatype_precision: [:dtype, :H5Tget_precision, 0],
    datatype_offset: [:dtype, :H5Tget_offset, -1],
    datatype_order: [:dtype, :H5Tget_order, :H5T_ORDER_ERROR],
    dataset_layout: [:chunks, :H5Pget_layout, :H5D_LAYOUT_ERROR],
    selection_size: [:read, :H5Sget_select_npoints, -1]
  }.each do |name, (operation, function, failure)|
    test "reports native #{name} failures without using invalid metadata" do
      with_file do |file|
        dataset = file.create_dataset('values', [1, 2])
        replace_ffi_method(function, ->(*) { failure }) do
          replace_ffi_method(:H5Dread, ->(*) { flunk('Invalid metadata must not reach data I/O') }) do
            assert_raise(HDF5::NativeError) { dataset.public_send(operation) }
          end
        end
        assert_equal([1, 2], dataset.read.to_a)
      end
    end
  end

  test 'distinguishes a failed filter query from an unavailable filter' do
    with_file do |file|
      replace_ffi_method(:H5Zfilter_avail, ->(*) { -1 }) do
        assert_raise(HDF5::NativeError) { file.create_dataset('failed', [1], compression: :gzip) }
      end
      assert_false(file.key?('failed'))
    end
  end

  test 'reports an unavailable filter as an unsupported feature' do
    with_file do |file|
      replace_ffi_method(:H5Zfilter_avail, ->(*) { 0 }) do
        assert_raise(HDF5::UnsupportedFeatureError) { file.create_dataset('failed', [1], compression: :gzip) }
      end
      assert_false(file.key?('failed'))
    end
  end

  test 'temporary resource cleanup attempts every close after a failure' do
    calls = []
    replace_ffi_method(:H5Tclose, ->(id) { calls << [:type, id]; -1 }) do
      replace_ffi_method(:H5Sclose, ->(id) { calls << [:space, id]; 0 }) do
        error = assert_raise(HDF5::NativeError) do
          HDF5::Native.close([:H5Tclose, 100], [:H5Sclose, 200])
        end
        assert_include(error.message, 'H5Tclose')
      end
    end
    assert_equal([[:type, 100], [:space, 200]], calls)
  end

  test 'temporary resource cleanup preserves the original exception' do
    failure = HDF5::ConversionError.new('invalid value')
    calls = []
    replace_ffi_method(:H5Tclose, ->(id) { calls << id; -1 }) do
      replace_ffi_method(:H5Sclose, ->(id) { calls << id; -1 }) do
        error = assert_raise(HDF5::ConversionError) do
          begin
            raise failure
          ensure
            HDF5::Native.close([:H5Tclose, 100], [:H5Sclose, 200])
          end
        end
        assert_same(failure, error)
      end
    end
    assert_equal([100, 200], calls)
  end
end
