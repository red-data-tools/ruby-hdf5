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
            file["external"] = h5py.ExternalLink("other.h5", "/data")
            file["matrix"].attrs["scale"] = np.int64(2**40)
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
        assert_equal({ type: :external, filename: 'other.h5', path: '/data' }, file.link_info('external'))
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

  private

  def run_python(script, path)
    stdout, stderr, status = Open3.capture3(@python, '-c', script, path)
    assert_predicate(status, :success?, "Python failed:\n#{stdout}\n#{stderr}")
  end
end