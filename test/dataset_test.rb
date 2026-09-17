# frozen_string_literal: true

require_relative 'test_helper'

class DatasetTest < Test::Unit::TestCase
  test 'create float dataset' do
    Dir.mktmpdir do |dir|
      path = File.join(dir, 'float.h5')
      file = HDF5::File.create(path)
      dataset = file.create_dataset('values', [1.5, 2.5, 3.5])
      dataset.close
      file.close

      reopened = HDF5::File.open(path)
      loaded = reopened['values']
      assert_equal([3], loaded.shape)
      assert_equal(:float64, loaded.dtype.to_sym)
      assert_equal(Numo::DFloat[1.5, 2.5, 3.5], loaded.read)
      loaded.close
      reopened.close
    end
  end

  test 'preserves multidimensional Numo data' do
    Dir.mktmpdir do |dir|
      path = File.join(dir, 'matrix.h5')
      matrix = Numo::SFloat[[1.5, 2.5], [3.5, 4.5]]

      HDF5::File.create(path) do |file|
        file.create_dataset('matrix', matrix)
      end

      HDF5::File.open(path) do |file|
        dataset = file['matrix']
        assert_equal([2, 2], dataset.shape)
        assert_equal(:float32, dataset.dtype.to_sym)
        assert_equal(matrix, dataset.read)
      end
    end
  end

  test 'distinguishes null scalar and empty dataspaces' do
    with_file do |file|
      null = file.create_dataset('null', HDF5::Empty.new(:float32))
      scalar = file.create_dataset('scalar', 1.5)
      empty = file.create_dataset('empty', shape: [0, 3], dtype: :float32)
      assert_nil(null.shape)
      assert_nil(null.ndim)
      assert_equal(0, null.size)
      assert_kind_of(HDF5::Empty, null.read)
      assert_equal(:float32, null.read.dtype.to_sym)
      assert_equal([], scalar.shape)
      assert_equal([0, 3], empty.shape)
      assert_raise(HDF5::ShapeError) { null.resize([1]) }
    end
  end

  test 'enforces safe numeric casting for reads and writes' do
    with_file do |file|
      integers = file.create_dataset('integers', Numo::Int16[1, 2])
      floats = file.create_dataset('floats', Numo::DFloat[1.25, 2.5])
      assert_equal(Numo::SFloat[1, 2], integers.read(dtype: :float32))
      assert_raise(HDF5::ConversionError) { floats.read(dtype: :float32) }
      assert_equal(Numo::SFloat[1.25, 2.5], floats.read(dtype: :float32, casting: :unsafe))
      assert_raise(HDF5::ConversionError) { integers.write(Numo::Int64[3, 4]) }
      integers.write(Numo::Int64[3, 4], casting: :unsafe)
      assert_equal(Numo::Int16[3, 4], integers.read)
    end
  end

  test 'round trips bool and complex data' do
    Dir.mktmpdir do |dir|
      path = File.join(dir, 'special-numeric.h5')
      bits = Numo::Bit[[0, 1], [1, 0]]
      complex64 = Numo::SComplex[Complex(1, 2), Complex(3, 4)]
      complex128 = Numo::DComplex[Complex(5, 6)]

      HDF5::File.create(path) do |file|
        assert_equal(bits, file.create_dataset('bits', bits).read)
        assert_equal(complex64, file.create_dataset('complex64', complex64).read)
        assert_equal(complex128, file.create_dataset('complex128', complex128).read)
        file.attrs['enabled'] = true
        assert_true(file.attrs['enabled'])
      end
    end
  end

  test 'preserves int64 values on create' do
    with_file do |file|
      dataset = file.create_dataset('large', [1 << 40])
      assert_equal(Numo::Int64[1 << 40], dataset.read)
    end
  end

  test 'rejects writes with a mismatched shape' do
    with_file do |file|
      dataset = file.create_dataset('ints', [1, 2, 3])
      assert_raise(HDF5::ShapeError) { dataset.write([1]) }
    end
  end

  test 'rejects append to a Null dataset with an HDF5 error' do
    with_file do |file|
      dataset = file.create_dataset('null', HDF5::Empty.new(:int16))
      assert_raise(HDF5::ShapeError) { dataset.append(Numo::Int16[1]) }
    end
  end

  test 'removes a newly created dataset when its initial write fails' do
    with_file do |file|
      replace_ffi_method(:H5Dwrite, ->(*_args) { -1 }) do
        assert_raise(HDF5::NativeError) { file.create_dataset('partial', [1, 2]) }
      end
      assert_false(file.key?('partial'))
    end
  end

  test 'safe typed widening writes using the source memory datatype' do
    with_file do |file|
      source = Numo::Int32[1, 2, 3]
      dataset = file.create_dataset('wide', source, dtype: :int64)
      original_write = HDF5::FFI.method(:H5Dwrite).super_method
      memory_types = []
      replace_ffi_method(:H5Dwrite, ->(*args) { memory_types << args[1]; original_write.call(*args) }) do
        dataset.write(source)
      end
      assert_equal([HDF5::FFI.H5T_NATIVE_INT32_g], memory_types)
      assert_equal(:int64, dataset.dtype.to_sym)
      assert_equal(source.to_a, dataset.read.to_a)
    end
  end

  {
    integers: Numo::Int32[1, 2, 3], floats: Numo::SFloat[1.5, 2.5, 3.5],
    complex: Numo::SComplex[Complex(1, 2), Complex(3, 4), Complex(5, 6)]
  }.each do |name, values|
    test "writes #{name} to a complex dataset" do
      with_file do |file|
        dataset = file.create_dataset('complex', values, dtype: :complex128)
        assert_equal(Numo::DComplex.cast(values), dataset.read)
        dataset.write(values)
        assert_equal(Numo::DComplex.cast(values), dataset.read)
      end
    end
  end

  test 'safe scalar writes reject overflow and fractional values before changing data' do
    with_file do |file|
      scalar = file.create_dataset('scalar', Numo::Int8.cast(7))
      assert_raise(HDF5::ConversionError) { scalar.write(300) }
      assert_raise(HDF5::ConversionError) { scalar.write(1.9) }
      assert_equal(7, scalar.read)
      scalar.write(300, casting: :unsafe)
      assert_equal(44, scalar.read)
      array = file.create_dataset('array', [1, 2, 3], dtype: :int8)
      assert_raise(HDF5::ConversionError) { array.write(300) }
      assert_equal([1, 2, 3], array.read.to_a)
    end
  end

  test 'Ruby arrays use explicit dtype and validate range before Numo conversion' do
    with_file do |file|
      assert_equal([1, 2], file.create_dataset('small', [1, 2], dtype: :int16).read.to_a)
      maximum = (1 << 64) - 1
      assert_equal([maximum], file.create_dataset('unsigned', [maximum], dtype: :uint64).read.to_a)
      assert_raise(HDF5::ConversionError) { file.create_dataset('overflow', [maximum + 1], dtype: :uint64) }
      assert_false(file.key?('overflow'))
      assert_raise(HDF5::ConversionError) { file.create_dataset('typed', Numo::Int64[1], dtype: :int16) }
      assert_equal([1], file.create_dataset('unsafe', Numo::Int64[1], dtype: :int16, casting: :unsafe).read.to_a)
      assert_equal([2, 0], file.create_dataset('empty', [[], []], dtype: :int16).shape)
    end
  end

  test 'ragged and inexact mixed input is rejected without creating a dataset' do
    with_file do |file|
      assert_raise(HDF5::ShapeError) { file.create_dataset('ragged', [[1, 2], [3]]) }
      assert_false(file.key?('ragged'))
      assert_raise(HDF5::ConversionError) { file.create_dataset('mixed', [9_007_199_254_740_993, 0.5]) }
      assert_false(file.key?('mixed'))
      assert_raise(HDF5::ConversionError) { file.create_dataset('float32', [0.1], dtype: :float32) }
      assert_equal([1.5, 0.5], file.create_dataset('exact', [1.5, 0.5], dtype: :float32).read.to_a)
      assert_equal([1.0, 0.5], file.create_dataset('mixed_exact', [1, 0.5]).read.to_a)
    end
  end

  test 'scalar read_into returns and updates the destination' do
    with_file do |file|
      dataset = file.create_dataset('scalar', Numo::Int16.cast(7))
      destination = Numo::Int16.zeros
      assert_same(destination, dataset.read_into(destination))
      assert_equal(7, destination.extract)
    end
  end

  test 'selected scalar read_into returns and updates the destination' do
    with_file do |file|
      dataset = file.create_dataset('array', Numo::Int16[5, 9])
      destination = Numo::Int16.zeros
      assert_same(destination, dataset.read_into(destination, selection: [1]))
      assert_equal(9, destination.extract)
    end
  end

  test 'read_into rejects mismatched destination shapes before native I/O' do
    with_file do |file|
      dataset = file.create_dataset('scalar', Numo::Int16.cast(7))
      replace_ffi_method(:H5Dread, ->(*) { flunk('Mismatched destinations must not perform I/O') }) do
        assert_raise(HDF5::ShapeError) { dataset.read_into(Numo::Int16.zeros(1)) }
      end
    end
  end

  [true, false].each do |value|
    test "bool scalar read_into preserves #{value}" do
      with_file do |file|
        dataset = file.create_dataset('scalar', value)
        destination = Numo::Bit.zeros
        assert_same(destination, dataset.read_into(destination))
        assert_equal(value ? 1 : 0, destination.extract)
      end
    end

    test "selected bool read_into preserves #{value}" do
      with_file do |file|
        dataset = file.create_dataset('bits', [value])
        destination = Numo::Bit.zeros
        assert_same(destination, dataset.read_into(destination, selection: [0]))
        assert_equal(value ? 1 : 0, destination.extract)
      end
    end
  end

  test 'bool array read_into preserves all values' do
    with_file do |file|
      dataset = file.create_dataset('bits', [true, false])
      destination = Numo::Bit.zeros(2)
      assert_same(destination, dataset.read_into(destination))
      assert_equal([1, 0], destination.to_a)
    end
  end

  test 'real to complex reads require an explicit cast without performing I/O' do
    with_file do |file|
      [Numo::Int16[1, 2], Numo::SFloat[1.5, 2.5]].each_with_index do |values, index|
        dataset = file.create_dataset("real_#{index}", values)
        assert_equal(values, dataset.read)
        assert_equal(Numo::DComplex.cast(values), Numo::DComplex.cast(dataset.read))
        destination = Numo::DComplex.zeros(2)
        replace_ffi_method(:H5Dread, ->(*) { flunk('Unsupported conversion must not perform I/O') }) do
          %i[safe unsafe].each do |casting|
            assert_raise(HDF5::ConversionError) { dataset.read(dtype: :complex128, casting:) }
            assert_raise(HDF5::ConversionError) { dataset.read_into(destination, casting:) }
          end
        end
        assert_equal([Complex(0, 0), Complex(0, 0)], destination.to_a)
        assert_equal([0], dataset.read(selection: [0...0], dtype: :complex128).shape)
      end
    end
  end

  {
    selection: ->(dataset) { dataset[999] },
    iteration: ->(dataset) { dataset.each_block(max_bytes: 8).to_a },
    read_into: ->(dataset) { dataset.read_into(Numo::Int16.zeros) }
  }.each do |name, operation|
    test "Null datasets reject #{name}" do
      with_file do |file|
        dataset = file.create_dataset('null', HDF5::Empty.new(:int16))
        assert_raise(HDF5::ShapeError) { operation.call(dataset) }
        assert_kind_of(HDF5::Empty, dataset.read)
      end
    end
  end

  [[], [2]].each do |shape|
    test "Null datasets reject explicit shape #{shape.inspect}" do
      with_file do |file|
        assert_raise(HDF5::ShapeError) do
          file.create_dataset('null', HDF5::Empty.new(:int16), shape:)
        end
        assert_false(file.key?('null'))
      end
    end
  end

  test 'boolean scalar broadcast and fillvalue work without numeric coercion' do
    with_file do |file|
      dataset = file.create_dataset('bits', shape: [2, 3], dtype: :bool, fillvalue: true)
      assert_equal(true, dataset.fillvalue)
      assert_equal([[1, 1, 1], [1, 1, 1]], dataset.read.to_a)
      dataset.write(false)
      dataset[1, true] = true
      assert_equal([[0, 0, 0], [1, 1, 1]], dataset.read.to_a)
      scalar = file.create_dataset('scalar_bool', true)
      assert_equal(true, scalar.read)
    end
  end

  test 'scalar broadcasting reuses a bounded buffer for a strided selection with a dropped axis' do
    with_file do |file|
      dataset = file.create_dataset('large', shape: [2, 70_003], dtype: :int64)
      original_write = HDF5::FFI.method(:H5Dwrite).super_method
      buffers = []
      replacement = lambda do |*args|
        buffers << [args.last.address, args.last.size]
        original_write.call(*args)
      end
      replace_ffi_method(:H5Dwrite, replacement) do
        dataset.write(9, selection: [1, HDF5.slice(1...70_003, step: 2)])
      end
      assert_operator(buffers.length, :>, 1)
      assert_equal(1, buffers.map(&:first).uniq.length)
      assert_true(buffers.all? { |_, bytes| bytes <= 256 * 1024 })
      assert_equal(0, dataset[0, 1])
      assert_equal(0, dataset[1, 2])
      assert_equal(9, dataset[1, 70_001])
      assert_equal(Numo::Int64.new(35_001).fill(9), dataset[1, HDF5.slice(1...70_003, step: 2)])
    end
  end

  { negative: [-1], fractional: [1.5], scalar: 2, missing: nil }.each do |name, shape|
    test "rejects #{name} dataset shapes before native allocation" do
      with_file do |file|
        replace_ffi_method(:H5Screate_simple, ->(*) { flunk('Invalid shapes must not allocate dataspaces') }) do
          expected = shape.nil? ? ArgumentError : HDF5::ShapeError
          assert_raise(expected) { file.create_dataset('invalid', shape:, dtype: :int16) }
        end
        assert_false(file.key?('invalid'))
      end
    end
  end

  { numeric: [1], string: 'hello', null: HDF5::Empty.new(:int16) }.each do |name, value|
    test "#{name} reads reject invalid casting modes before native I/O" do
      with_file do |file|
        dataset = file.create_dataset('values', value)
        replace_ffi_method(:H5Dread, ->(*) { flunk('Invalid casting modes must not perform I/O') }) do
          assert_raise(ArgumentError) { dataset.read(casting: :invalid) }
        end
      end
    end
  end
end
