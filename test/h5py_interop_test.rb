# frozen_string_literal: true

require_relative 'test_helper'
require 'open3'
require 'tmpdir'

class H5pyInteropTest < Test::Unit::TestCase
  def setup
    @python = ENV['H5PY_PYTHON']
    omit('Set H5PY_PYTHON to a Python executable with h5py') unless @python && File.executable?(@python)
  end

  test 'reads numeric data and metadata written by h5py' do
    Dir.mktmpdir do |dir|
      path = File.join(dir, 'python.h5')
      run_python(<<~PYTHON, path)
        import h5py
        import numpy as np
        import sys

        with h5py.File(sys.argv[1], "w") as file:
            file.create_dataset("matrix", data=np.array([[1, 2], [3, 4]], dtype="<u2"))
            file.create_dataset("scalar", data=np.float32(1.5))
            file.create_dataset("empty", shape=(0, 3), dtype="<i8")
            file.create_dataset("bits", data=np.array([[False, True], [True, False]], dtype=np.bool_))
            file.create_dataset("complex", data=np.array([1+2j, 3+4j], dtype="<c8"))
            file.create_dataset("big_complex", data=np.array([1+2j, 3+4j], dtype=">c16"))
            file.create_dataset("ascii", data="hello", dtype=h5py.string_dtype("ascii"))
            file.create_dataset("null", data=h5py.Empty("i2"))
            file.create_dataset("null_text", data=h5py.Empty(h5py.string_dtype("utf-8")))
            file["external"] = h5py.ExternalLink("other.h5", "/data")
            file["matrix"].attrs["scale"] = np.int64(2**40)
            file["matrix"].attrs["missing"] = h5py.Empty("i2")
      PYTHON

      HDF5::File.open(path) do |file|
        matrix = file['matrix']
        assert_equal(:uint16, matrix.dtype.to_sym)
        assert_equal([2, 2], matrix.shape)
        assert_equal(Numo::UInt16[[1, 2], [3, 4]], matrix.read)
        assert_equal(1.5, file['scalar'].read)
        assert_equal([0, 3], file['empty'].shape)
        assert_equal(1 << 40, matrix.attrs['scale'])
        assert_equal(Numo::Bit[[0, 1], [1, 0]], file['bits'].read)
        assert_equal(Numo::SComplex[Complex(1, 2), Complex(3, 4)], file['complex'].read)
        assert_equal(:big, file['big_complex'].dtype.byteorder)
        assert_equal(Numo::DComplex[Complex(1, 2), Complex(3, 4)], file['big_complex'].read)
        assert_equal('hello', file['ascii'].read)
        assert_equal(Encoding::US_ASCII, file['ascii'].dtype.encoding)
        assert_kind_of(HDF5::Empty, file['null'].read)
        assert_kind_of(HDF5::Empty, file['null_text'].read)
        assert_equal(:string, file['null_text'].read.dtype.to_sym)
        assert_kind_of(HDF5::Empty, matrix.attrs['missing'])
        assert_equal(:int16, matrix.attrs['missing'].dtype.to_sym)
        assert_equal({ type: :external, filename: 'other.h5', path: '/data' }, file.link_info('external'))
      end
    end
  end

  test 'reads both byte orders across supported integer float and complex types' do
    Dir.mktmpdir do |dir|
      path = File.join(dir, 'byteorders.h5')
      run_python(<<~PYTHON, path)
        import h5py
        import numpy as np
        import sys

        names = ("int8", "uint8", "int16", "uint16", "int32", "uint32",
                 "int64", "uint64", "float32", "float64", "complex64", "complex128")
        with h5py.File(sys.argv[1], "w") as file:
            for name in names:
                values = [1+2j, 3+4j] if name.startswith("complex") else [1, 2]
                for prefix, order in (("little", "<"), ("big", ">")):
                    dtype = np.dtype(name).newbyteorder(order)
                    file.create_dataset(name + "_" + prefix, data=np.array(values, dtype=dtype))
      PYTHON

      HDF5::File.open(path) do |file|
        HDF5::DType::TYPES.each do |name, (numo_class, _, _, kind, itemsize)|
          next if kind == :bool

          values = kind == :complex ? [Complex(1, 2), Complex(3, 4)] : [1, 2]
          %i[little big].each do |order|
            dataset = file["#{name}_#{order}"]
            assert_equal(name, dataset.dtype.to_sym)
            assert_equal(order, dataset.dtype.byteorder) if itemsize > 1
            assert_equal(numo_class.cast(values), dataset.read)
          end
        end
      end
    end
  end

  test 'writes numeric data and metadata readable by h5py' do
    Dir.mktmpdir do |dir|
      path = File.join(dir, 'ruby.h5')
      HDF5::File.create(path) do |file|
        matrix = file.create_dataset('matrix', Numo::Int16[[1, 2], [3, 4]], chunks: [1, 2], compression: :gzip)
        matrix.attrs['scale'] = 1 << 40
        file.create_dataset('empty', shape: [0, 3], dtype: :uint64)
        file.create_dataset('bits', Numo::Bit[0, 1, 1])
        file.create_dataset('complex', Numo::DComplex[Complex(1, 2), Complex(3, 4)])
      end

      run_python(<<~PYTHON, path)
        import h5py
        import numpy as np
        import sys

        with h5py.File(sys.argv[1], "r") as file:
            assert file["matrix"].dtype == np.dtype("<i2")
            assert file["matrix"].shape == (2, 2)
            assert np.array_equal(file["matrix"][:], np.array([[1, 2], [3, 4]], dtype="<i2"))
            assert file["matrix"].compression == "gzip"
            assert int(file["matrix"].attrs["scale"]) == 2**40
            assert file["empty"].dtype == np.dtype("<u8")
            assert file["empty"].shape == (0, 3)
            assert file["bits"].dtype == np.dtype(np.bool_)
            assert np.array_equal(file["bits"][:], np.array([False, True, True]))
            assert file["complex"].dtype == np.dtype("<c16")
            assert np.array_equal(file["complex"][:], np.array([1+2j, 3+4j], dtype="<c16"))
      PYTHON
    end
  end

  test 'writes explicit UTF-8 strings empty arrays and Null values readable by h5py' do
    Dir.mktmpdir do |dir|
      path = File.join(dir, 'ruby_strings.h5')
      HDF5::File.create(path) do |file|
        file.create_dataset('scalar', '日本語', dtype: :string)
        file.create_dataset('labels', %w[alpha 日本語], dtype: :string)
        file.create_dataset('empty', [], dtype: :string)
        file.create_dataset('matrix', [[], []], dtype: :string)
        file.create_dataset('objects', Numo::RObject.new(0, 3), dtype: :string)
        file.create_dataset('allocated', shape: [0, 3], dtype: :string)
        file.create_dataset('null', HDF5::Empty.new(:string))
        file.attrs.create('empty', [], dtype: :string)
        file.attrs.create('matrix', [[], []], dtype: :string)
        file.attrs['labels'] = %w[alpha 日本語]
        file.attrs['null'] = HDF5::Empty.new(:string)
      end

      run_python(<<~PYTHON, path)
        import h5py
        import sys

        with h5py.File(sys.argv[1], "r") as file:
            for name in file:
                info = h5py.check_string_dtype(file[name].dtype)
                assert info.encoding == "utf-8" and info.length is None
            assert file["scalar"].asstr()[()] == "日本語"
            assert file["labels"].asstr()[:].tolist() == ["alpha", "日本語"]
            for name, shape in (("empty", (0,)), ("matrix", (2, 0)),
                                ("objects", (0, 3)), ("allocated", (0, 3))):
                assert file[name].shape == shape
                assert file[name].asstr()[:].shape == shape
            assert file["null"].shape is None
            assert isinstance(file["null"][()], h5py.Empty)
            assert h5py.check_string_dtype(file["null"][()].dtype).encoding == "utf-8"
            for name, shape in (("empty", (0,)), ("matrix", (2, 0))):
                assert file.attrs[name].shape == shape
                info = h5py.check_string_dtype(file.attrs.get_id(name).dtype)
                assert info.encoding == "utf-8" and info.length is None
            assert file.attrs["labels"].tolist() == ["alpha", "日本語"]
            assert isinstance(file.attrs["null"], h5py.Empty)
            info = h5py.check_string_dtype(file.attrs["null"].dtype)
            assert info.encoding == "utf-8" and info.length is None
      PYTHON
    end
  end

  test 'reads and updates empty and Null UTF-8 strings created by h5py' do
    Dir.mktmpdir do |dir|
      path = File.join(dir, 'python_strings.h5')
      run_python(<<~PYTHON, path)
        import h5py
        import numpy as np
        import sys

        dtype = h5py.string_dtype("utf-8")
        with h5py.File(sys.argv[1], "w") as file:
            file.create_dataset("labels", data=["alpha", "日本語"], dtype=dtype)
            file.create_dataset("empty", shape=(0,), dtype=dtype)
            file.create_dataset("matrix", shape=(2, 0), dtype=dtype)
            file.create_dataset("null", data=h5py.Empty(dtype))
            file.attrs.create("empty", np.empty((0,), dtype=dtype), dtype=dtype)
            file.attrs.create("matrix", np.empty((2, 0), dtype=dtype), dtype=dtype)
            file.attrs["null"] = h5py.Empty(dtype)
      PYTHON

      HDF5::File.open(path, 'r+') do |file|
        assert_equal(%w[alpha 日本語], file['labels'].read.to_a)
        { 'empty' => [0], 'matrix' => [2, 0] }.each do |name, shape|
          assert_equal(shape, file[name].read.shape)
          assert_equal(Encoding::UTF_8, file[name].dtype.encoding)
          assert_equal(shape, file.attrs[name].shape)
        end
        assert_equal(:string, file['null'].read.dtype.to_sym)
        assert_equal(:string, file.attrs['null'].dtype.to_sym)
        file['empty'].write([])
        file['matrix'].write([[], []])
        file.attrs.modify('empty', [])
        file.attrs.modify('matrix', [[], []])
        file.create_dataset('null_copy', file['null'].read)
        file.attrs['null_copy'] = file.attrs['null']
      end
    end
  end

  private

  def run_python(script, path)
    stdout, stderr, status = Open3.capture3(@python, '-c', script, path)
    assert_predicate(status, :success?, "Python failed:\n#{stdout}\n#{stderr}")
  end
end
