# frozen_string_literal: true

require_relative 'test_helper'

class DtypeTest < Test::Unit::TestCase
  test 'describes datatype storage details' do
    with_file do |file|
      dtype = file.create_dataset('values', Numo::UInt16[1, 2]).dtype
      assert_equal(:integer, dtype.kind)
      assert_equal(:uint16, dtype.to_sym)
      assert_equal(:little, dtype.byteorder)
      assert_equal(16, dtype.precision)
      assert_equal(0, dtype.offset)
      assert_equal(:H5T_INTEGER, dtype.hdf5_class)
    end
  end

  test 'big endian complex metadata follows both component types' do
    with_file do |file|
      type_id = HDF5::FFI.H5Tcreate(:H5T_COMPOUND, 16)
      HDF5::FFI.H5Tinsert(type_id, 'r', 0, HDF5::FFI.H5T_IEEE_F64BE_g)
      HDF5::FFI.H5Tinsert(type_id, 'i', 8, HDF5::FFI.H5T_IEEE_F64BE_g)
      dims = FFI::MemoryPointer.new(:ulong_long).tap { |pointer| pointer.write_ulong_long(2) }
      space_id = HDF5::FFI.H5Screate_simple(1, dims, nil)
      dataset_id = HDF5::FFI.H5Dcreate2(file.instance_variable_get(:@file_id), 'complex', type_id, space_id, 0, 0, 0)
      HDF5::FFI.H5Dclose(dataset_id)
      dataset = file['complex']
      values = Numo::DComplex[Complex(1, 2), Complex(3, 4)]
      dataset.write(values)
      assert_equal(:complex128, dataset.dtype.to_sym)
      assert_equal(:big, dataset.dtype.byteorder)
      assert_equal(values, dataset.read)
    ensure
      HDF5::FFI.H5Sclose(space_id) if space_id
      HDF5::FFI.H5Tclose(type_id) if type_id
    end
  end

  test 'unsupported dtype symbols raise the public unsupported type error' do
    assert_raise(HDF5::UnsupportedTypeError) { HDF5::DType.for_symbol(:unknown) }
  end

  test 'unsupported Numo classes raise the public unsupported type error' do
    assert_raise(HDF5::UnsupportedTypeError) { HDF5::DType.for_numo(Numo::RObject[1]) }
  end

  test 'unsupported native numeric sizes do not leak KeyError' do
    type = HDF5::FFI.H5T_STD_I16LE_g
    replace_ffi_method(:H5Tget_size, ->(*) { 3 }) do
      replace_ffi_method(:H5Tget_precision, ->(*) { 24 }) do
        assert_raise(HDF5::UnsupportedTypeError) { HDF5::DType.for_hdf5(type) }
      end
    end
  end
end
