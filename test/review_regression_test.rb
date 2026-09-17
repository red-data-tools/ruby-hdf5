# frozen_string_literal: true

require_relative 'test_helper'
require 'tmpdir'

class ReviewRegressionTest < Test::Unit::TestCase
  test 'homogeneous Array fast paths preserve range shape and nonfinite floats' do
    helper = HDF5::DataHelpers
    assert_equal([[1, 2], [3, 4]], helper.normalize_data([[1, 2], [3, 4]]).to_a)
    assert_equal(:uint64, HDF5::DType.for_numo(helper.normalize_data([(1 << 64) - 1])).to_sym)
    [[-(1 << 63) - 1], [(1 << 64)], [-1, (1 << 63)], [[(1 << 64)]]].each do |data|
      assert_raise(HDF5::ConversionError) { helper.normalize_data(data) }
    end
    assert_raise(HDF5::ShapeError) { helper.normalize_data([[1.0], [2.0, 3.0]]) }
    floats = helper.normalize_data([Float::NAN, Float::INFINITY, -Float::INFINITY]).to_a
    assert_true(floats[0].nan?)
    assert_equal([Float::INFINITY, -Float::INFINITY], floats[1..])
    assert_raise(HDF5::ConversionError) { helper.normalize_data([1, nil], dtype: HDF5::DType.for_symbol(:int8)) }
  end

  test 'safe typed widening keeps the source buffer and native memory datatype' do
    source = Numo::Int32[1, 2, 3]
    target = HDF5::DType.for_symbol(:int64)
    assert_same(source, HDF5::DataHelpers.normalize_data(source, dtype: target, convert: false))
    with_file do |file|
      dataset = file.create_dataset('wide', source, dtype: :int64)
      assert_equal(:int64, dataset.dtype.to_sym)
      original_write = HDF5::FFI.method(:H5Dwrite).super_method
      memory_types = []
      replace_ffi_method(:H5Dwrite, lambda { |*args| memory_types << args[1]; original_write.call(*args) }) do
        dataset.write(source)
      end
      assert_equal([HDF5::FFI.H5T_NATIVE_INT32_g], memory_types)
      assert_equal([1, 2, 3], dataset.read.to_a)
      dataset.attrs['wide'] = Numo::Int64[0, 0, 0]
      dataset.attrs.modify('wide', source)
      assert_equal([1, 2, 3], dataset.attrs['wide'].to_a)
      complex = file.create_dataset('complex', source, dtype: :complex128)
      assert_equal([Complex(1, 0), Complex(2, 0), Complex(3, 0)], complex.read.to_a)
      complex.write(Numo::SFloat[1.5, 2.5, 3.5])
      assert_equal([Complex(1.5, 0), Complex(2.5, 0), Complex(3.5, 0)], complex.read.to_a)
      small_complex = Numo::SComplex[Complex(1, 2), Complex(3, 4), Complex(5, 6)]
      complex.write(small_complex)
      assert_equal(small_complex.to_a, complex.read.to_a)
      dataset.attrs['complex'] = Numo::DComplex[0, 0, 0]
      dataset.attrs.modify('complex', source)
      assert_equal([Complex(1, 0), Complex(2, 0), Complex(3, 0)], dataset.attrs['complex'].to_a)
      bits = Numo::Bit[1, 0]
      assert_raise(HDF5::ConversionError) { HDF5::DataHelpers.normalize_data(bits, dtype: target, convert: false) }
      narrowed = HDF5::DataHelpers.normalize_data(source, dtype: HDF5::DType.for_symbol(:int8), casting: :unsafe,
                                                         convert: false)
      assert_kind_of(Numo::Int8, narrowed)
    end
  end

  def with_file
    Dir.mktmpdir do |dir|
      HDF5::File.create(File.join(dir, 'review.h5')) { |file| yield file }
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

  test 'a user block exception preserves the created dataset and closes its handle' do
    with_file do |file|
      opened = nil
      assert_raise(RuntimeError) do
        file.create_dataset('values', [1, 2]) do |dataset|
          opened = dataset
          dataset[0] = 8
          raise 'user calculation failed'
        end
      end
      assert_true(opened.closed?)
      assert_equal([8, 2], file['values'].read.to_a)
    end
  end

  test 'scalar read_into and selected scalar read_into return the destination' do
    with_file do |file|
      scalar = file.create_dataset('scalar', Numo::Int16.cast(7))
      destination = Numo::Int16.zeros
      assert_same(destination, scalar.read_into(destination))
      assert_equal(7, destination.extract)
      array = file.create_dataset('array', Numo::Int16[5, 9])
      assert_same(destination, array.read_into(destination, selection: [1]))
      assert_equal(9, destination.extract)
      replace_ffi_method(:H5Dread, ->(*) { flunk('I/O must not run for a mismatched destination') }) do
        assert_raise(HDF5::Error) { scalar.read_into(Numo::Int16.zeros(1)) }
      end
    end
  end

  test 'Null datasets and attributes retain their absence of values' do
    with_file do |file|
      dataset = file.create_dataset('null', HDF5::Empty.new(:int16))
      assert_kind_of(HDF5::Empty, dataset.read)
      assert_raise(HDF5::Error) { dataset[999] }
      assert_raise(HDF5::Error) { dataset.each_block(max_bytes: 8).to_a }
      assert_raise(HDF5::Error) { dataset.read_into(Numo::Int16.zeros) }
      space_id = HDF5::FFI.H5Screate(:H5S_NULL)
      attr_id = HDF5::FFI.H5Acreate2(dataset.instance_variable_get(:@dataset_id), 'null',
                                    HDF5::FFI.H5T_STD_I16LE_g, space_id, 0, 0)
      HDF5::FFI.H5Aclose(attr_id)
      HDF5::FFI.H5Sclose(space_id)
      attribute = dataset.attrs['null']
      assert_kind_of(HDF5::Empty, attribute)
      assert_equal(:int16, attribute.dtype.to_sym)
      assert_raise(HDF5::ShapeError) { dataset.attrs.modify('null', 0) }
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

  test 'invalid UTF-8 input does not replace existing dataset or attribute data' do
    with_file do |file|
      bad = "\xff".b.force_encoding(Encoding::UTF_8)
      assert_raise(HDF5::Error) { file.create_dataset('bad', bad) }
      assert_false(file.key?('bad'))
      dataset = file.create_dataset('text', 'valid')
      assert_raise(HDF5::Error) { dataset.write(bad) }
      assert_equal('valid', dataset.read)
      dataset.attrs['text'] = 'valid'
      assert_raise(HDF5::Error) { dataset.attrs['text'] = bad }
      assert_raise(HDF5::Error) { dataset.attrs.modify('text', bad) }
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
      assert_raise(HDF5::Error) { dataset.write('日本語') }
      assert_equal('hello', dataset.read)

      attr_id = HDF5::FFI.H5Acreate2(file.instance_variable_get(:@file_id), 'ascii', type_id, space_id, 0, 0)
      buffer, pointers = HDF5::StringCodec.buffer_for_values(['hello'])
      HDF5::FFI.H5Awrite(attr_id, type_id, buffer)
      assert_equal(1, pointers.length)
      HDF5::FFI.H5Aclose(attr_id)
      assert_raise(HDF5::Error) { file.attrs.modify('ascii', '日本語') }
      assert_equal('hello', file.attrs['ascii'])

      # HDF5 itself accepts invalid bytes; the text reader must reject them.
      dataset_id = dataset.instance_variable_get(:@dataset_id)
      buffer, pointers = HDF5::StringCodec.buffer_for_values(['日本語'])
      HDF5::FFI.H5Dwrite(dataset_id, type_id, 0, 0, 0, buffer)
      assert_equal(1, pointers.length)
      assert_raise(HDF5::Error) { dataset.read }
    ensure
      HDF5::FFI.H5Sclose(space_id) if space_id
      HDF5::FFI.H5Tclose(type_id) if type_id
    end
  end

  test 'reclaim failure closes every temporary dataspace' do
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
              assert_raise(HDF5::Error) { dataset.read }
              assert_empty(spaces)
              original_read = HDF5::FFI.method(:H5Dread).super_method
              replace_ffi_method(:H5Dread, ->(*args) { original_read.call(*args); -1 }) do
                error = assert_raise(HDF5::Error) { dataset.read }
                assert_equal('Failed to read string dataset', error.message)
                assert_empty(spaces)
              end
            end
          end
        end
      end
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

  test 'iteration and hierarchy blocks allow other threads to read' do
    with_file do |file|
      dataset = file.create_dataset('values', [1, 2], chunks: [1])
      dataset.each_block(max_bytes: 8) { assert_thread_can_read(dataset) }
      dataset.each_chunk { assert_thread_can_read(dataset) }
      file.each_key { assert_thread_can_read(dataset) }
      file.open_dataset('values') { |opened| assert_thread_can_read(opened) }
      file.create_dataset('created', [1]) { |opened| assert_thread_can_read(opened) }
      file.create_group('group') do |group|
        assert_thread_can_read(dataset)
        group.create_dataset('created', [2]) { |opened| assert_thread_can_read(opened) }
      end
    end
  end

  test 'close waits for an active read to finish' do
    with_file do |file|
      dataset = file.create_dataset('values', [1, 2])
      entered = Queue.new
      release = Queue.new
      closing = Queue.new
      original_read = HDF5::FFI.method(:H5Dread).super_method
      replace_ffi_method(:H5Dread, ->(*args) { entered << true; release.pop; original_read.call(*args) }) do
        reader = Thread.new { dataset.read }
        entered.pop
        closer = Thread.new { closing << true; file.close }
        closing.pop
        assert_nil(closer.join(0.05))
        release << true
        assert_equal([1, 2], reader.value.to_a)
        closer.value
        assert_true(dataset.closed?)
      ensure
        release << true
        reader&.join(1)
        closer&.join(1)
      end
    end
  end

  private

  def assert_thread_can_read(dataset)
    worker = Thread.new { dataset.read }
    assert_not_nil(worker.join(1), 'A user block must not hold the HDF5 lock')
    assert_not_nil(worker.value)
  ensure
    worker&.kill&.join if worker&.alive?
  end
end
