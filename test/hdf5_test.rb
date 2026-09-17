# frozen_string_literal: true

require_relative 'test_helper'
require 'tmpdir'

class HDF5Test < Test::Unit::TestCase
  test 'VERSION' do
    assert do
      ::HDF5.const_defined?(:VERSION)
    end
  end

  test 'libversion' do
    major = FFI::MemoryPointer.new(:uint)
    minor = FFI::MemoryPointer.new(:uint)
    release = FFI::MemoryPointer.new(:uint)
    HDF5::FFI.H5get_libversion(major, minor, release)
    assert_include([1, 2], major.read_uint)
    assert_kind_of(Integer, minor.read_uint)
    assert_kind_of(Integer, release.read_uint)
  end

  test 'selects the FFI backend by HDF5 version' do
    assert_equal('ffi_10', HDF5::FFI.send(:backend_for_version, 1, 10, 0))
    assert_equal('ffi_10', HDF5::FFI.send(:backend_for_version, 1, 13, 9))
    assert_equal('ffi_14', HDF5::FFI.send(:backend_for_version, 1, 14, 0))
    assert_equal('ffi_20', HDF5::FFI.send(:backend_for_version, 2, 0, 0))
    assert_equal('ffi_20', HDF5::FFI.send(:backend_for_version, 2, 2, 0))
    assert_raise(RuntimeError) { HDF5::FFI.send(:backend_for_version, 1, 15, 0) }
    assert_raise(RuntimeError) { HDF5::FFI.send(:backend_for_version, 2, 3, 0) }
    assert_raise(RuntimeError) { HDF5::FFI.send(:backend_for_version, 3, 0, 0) }

    error = assert_raise(RuntimeError) do
      HDF5::FFI.send(:backend_for_version, 1, 9, 9)
    end
    assert_equal('Unsupported HDF5 version 1.9.9', error.message)
  end

  test 'generated FFI backends attach only HDF5 functions' do
    backends = Dir[File.expand_path('../lib/hdf5/ffi_*.rb', __dir__)].sort

    backends.each do |backend|
      functions = File.foreach(backend).filter_map do |line|
        line[/^    attach_function '([^']+)'/, 1]
      end

      assert_equal([], functions.reject { |name| name.start_with?('H5') }, backend)
    end
  end

  test 'example' do
    f = HDF5::File.new(File.join(__dir__, 'fixtures', 'example.h5'))
    assert_equal(%w[foo], f.list_entries)
    g = f['foo']
    assert_equal(%w[bar_float bar_int], g.list_datasets)
    d = g['bar_float']
    assert_equal([10], d.shape)
    assert_equal(:float64, d.dtype.to_sym)
    assert_equal(Numo::DFloat[1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0, 10.0], d.read)
    d = g['bar_int']
    assert_equal([10], d.shape)
    assert_equal(:int64, d.dtype.to_sym)
    assert_equal(Numo::Int64[1, 2, 3, 4, 5, 6, 7, 8, 9, 10], d.read)
  end

  test 'create group and integer dataset' do
    Dir.mktmpdir do |dir|
      path = File.join(dir, 'integer.h5')
      file = HDF5::File.create(path)
      group = file.create_group('numbers')
      dataset = group.create_dataset('ints', [1, 2, 3, 4])
      dataset.close
      group.close
      file.close

      reopened = HDF5::File.open(path)
      assert_equal(%w[numbers], reopened.list_entries)
      loaded = reopened['numbers']['ints']
      assert_equal([4], loaded.shape)
      assert_equal(:int64, loaded.dtype.to_sym)
      assert_equal(Numo::Int64[1, 2, 3, 4], loaded.read)
      loaded.close
      reopened.close
    end
  end

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
    Dir.mktmpdir do |dir|
      path = File.join(dir, 'null.h5')

      HDF5::File.create(path) do |file|
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
        assert_raise(HDF5::Error) { null.resize([1]) }
      end
    end
  end

  test 'describes datatype storage details' do
    Dir.mktmpdir do |dir|
      path = File.join(dir, 'dtype.h5')

      HDF5::File.create(path) do |file|
        dtype = file.create_dataset('values', Numo::UInt16[1, 2]).dtype
        assert_equal(:integer, dtype.kind)
        assert_equal(:uint16, dtype.to_sym)
        assert_equal(:little, dtype.byteorder)
        assert_equal(16, dtype.precision)
        assert_equal(0, dtype.offset)
        assert_equal(:H5T_INTEGER, dtype.hdf5_class)
      end
    end
  end

  test 'enforces safe numeric casting for reads and writes' do
    Dir.mktmpdir do |dir|
      path = File.join(dir, 'casting.h5')

      HDF5::File.create(path) do |file|
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

  test 'reads a multidimensional selection' do
    Dir.mktmpdir do |dir|
      path = File.join(dir, 'selection.h5')
      matrix = Numo::Int16[[1, 2, 3], [4, 5, 6], [7, 8, 9]]

      HDF5::File.create(path) { |file| file.create_dataset('matrix', matrix) }

      HDF5::File.open(path) do |file|
        dataset = file['matrix']
        assert_equal(Numo::Int16[[4, 5, 6], [7, 8, 9]], dataset.read(selection: [1.., true]))
        assert_equal(Numo::Int16[2, 5, 8], dataset.read(selection: [true, 1]))
        assert_equal(Numo::Int16[[1, 2, 3], [7, 8, 9]], dataset.read(selection: [HDF5.slice(0..2, step: 2), true]))
        assert_equal(5, dataset.read(selection: [1, 1]))
      end
    end
  end

  test 'writes a multidimensional selection without changing other values' do
    Dir.mktmpdir do |dir|
      path = File.join(dir, 'selection-write.h5')
      matrix = Numo::Int16[[1, 2, 3], [4, 5, 6], [7, 8, 9]]

      HDF5::File.create(path) do |file|
        dataset = file.create_dataset('matrix', matrix)
        dataset[1.., true] = Numo::Int16[[10, 11, 12], [13, 14, 15]]
        dataset[0, 0] = 20
        dataset.write(-1, selection: [0, 1..])
        assert_equal(Numo::Int16[[20, -1, -1], [10, 11, 12], [13, 14, 15]], dataset.read)
        assert_equal(11, dataset[1, 1])
      end
    end
  end

  test 'reads a selection into an existing Numo array' do
    Dir.mktmpdir do |dir|
      path = File.join(dir, 'read-into.h5')
      matrix = Numo::Int16[[1, 2, 3], [4, 5, 6], [7, 8, 9]]

      HDF5::File.create(path) { |file| file.create_dataset('matrix', matrix) }

      HDF5::File.open(path) do |file|
        destination = Numo::Int16.zeros(2, 3)
        assert_same(destination, file['matrix'].read_into(destination, selection: [1.., true]))
        assert_equal(Numo::Int16[[4, 5, 6], [7, 8, 9]], destination)
        assert_raise(HDF5::Error) { file['matrix'].read_into(Numo::Int16.zeros(3)) }
      end
    end
  end

  test 'yields independent blocks within the requested byte budget' do
    Dir.mktmpdir do |dir|
      path = File.join(dir, 'each-block.h5')
      matrix = Numo::Int16[[1, 2, 3, 4], [5, 6, 7, 8], [9, 10, 11, 12]]

      HDF5::File.create(path) { |file| file.create_dataset('matrix', matrix) }

      HDF5::File.open(path) do |file|
        blocks = []
        file['matrix'].each_block(max_bytes: 4) do |selection, block|
          assert_operator(block.to_binary.bytesize, :<=, 4)
          blocks << [selection, block]
        end

        assert_equal(6, blocks.length)
        assert_equal([0...1, 0...2], blocks.first.first)
        assert_equal(Numo::Int16[[1, 2]], blocks.first.last)
        assert_equal(Numo::Int16[[11, 12]], blocks.last.last)
      end
    end
  end

  test 'creates a chunked gzip dataset' do
    Dir.mktmpdir do |dir|
      path = File.join(dir, 'chunked.h5')
      matrix = Numo::Int16[[1, 2, 3], [4, 5, 6], [7, 8, 9]]

      HDF5::File.create(path) do |file|
        dataset = file.create_dataset('matrix', matrix, chunks: [2, 3], compression: :gzip, compression_opts: 1,
                                                        shuffle: true, fletcher32: true)
        assert_equal([2, 3], dataset.chunks)
        assert_equal(matrix, dataset.read)
      end
    end
  end

  test 'limits automatic chunks to the target byte size' do
    Dir.mktmpdir do |dir|
      path = File.join(dir, 'auto-chunk.h5')

      HDF5::File.create(path) do |file|
        dataset = file.create_dataset('matrix', shape: [1000, 1000], dtype: :float64, chunks: :auto)
        assert_operator(dataset.chunks.inject(8, :*), :<=, 256 * 1024)
        assert_true(dataset.chunks.all?(&:positive?))
      end
    end
  end

  test 'writing an empty selection is a no-op' do
    Dir.mktmpdir do |dir|
      path = File.join(dir, 'empty-selection.h5')

      HDF5::File.create(path) do |file|
        dataset = file.create_dataset('values', [1, 2, 3])
        empty = Numo::Int64.zeros(0)
        assert_same(empty, dataset.write(empty, selection: [1...1]))
        assert_equal(Numo::Int64[1, 2, 3], dataset.read)
      end
    end
  end

  test 'round trips a UTF-8 string dataset' do
    Dir.mktmpdir do |dir|
      path = File.join(dir, 'string.h5')

      HDF5::File.create(path) do |file|
        dataset = file.create_dataset('greeting', 'hello, world')
        assert_equal('hello, world', dataset.read)
        dataset.write('Ruby HDF5')
        assert_equal('Ruby HDF5', dataset.read)
      end
    end
  end

  test 'round trips multidimensional UTF-8 string datasets and attributes' do
    Dir.mktmpdir do |dir|
      path = File.join(dir, 'string-arrays.h5')
      strings = [%w[alpha 日本語], %w[gamma delta]]

      HDF5::File.create(path) do |file|
        dataset = file.create_dataset('labels', strings)
        assert_equal([2, 2], dataset.shape)
        assert_equal(strings, dataset.read.to_a)
        dataset[1, true] = Numo::RObject['epsilon', 'zeta']
        assert_equal([%w[alpha 日本語], %w[epsilon zeta]], dataset.read.to_a)
        dataset.attrs['names'] = strings
        assert_equal(strings, dataset.attrs['names'].to_a)
        dataset.attrs.modify('names', [%w[one two], %w[three four]])
        assert_equal([%w[one two], %w[three four]], dataset.attrs['names'].to_a)
      end
    end
  end

  test 'round trips a UTF-8 string attribute' do
    Dir.mktmpdir do |dir|
      path = File.join(dir, 'string-attribute.h5')

      HDF5::File.create(path) do |file|
        dataset = file.create_dataset('values', [1])
        dataset.attrs['label'] = 'measurement'
        assert_equal('measurement', dataset.attrs['label'])
      end
    end
  end

  test 'yields chunked dataset regions including a partial final chunk' do
    Dir.mktmpdir do |dir|
      path = File.join(dir, 'each-chunk.h5')
      matrix = Numo::Int16[[1, 2, 3], [4, 5, 6], [7, 8, 9]]

      HDF5::File.create(path) { |file| file.create_dataset('matrix', matrix, chunks: [2, 2]) }

      HDF5::File.open(path) do |file|
        chunks = file['matrix'].each_chunk.to_a
        assert_equal(4, chunks.length)
        assert_equal([0...2, 0...2], chunks.first.first)
        assert_equal(Numo::Int16[[1, 2], [4, 5]], chunks.first.last)
        assert_equal([2...3, 2...3], chunks.last.first)
        assert_equal(Numo::Int16[[9]], chunks.last.last)
        assert_raise(HDF5::Error) { file.create_dataset('contiguous', matrix).each_chunk.to_a }
      end
    end
  end

  test 'resizes and appends to an extendible dataset' do
    Dir.mktmpdir do |dir|
      path = File.join(dir, 'extendible.h5')

      HDF5::File.create(path) do |file|
        dataset = file.create_dataset('matrix', shape: [0, 2], dtype: :int16, maxshape: [nil, 2], chunks: [2, 2])
        assert_equal([nil, 2], dataset.maxshape)
        assert_equal([2, 2], dataset.chunks)
        assert_same(dataset, dataset.append(Numo::Int16[[1, 2], [3, 4]]))
        dataset.append(Numo::Int16[[5, 6]])
        assert_equal([3, 2], dataset.shape)
        assert_equal(Numo::Int16[[1, 2], [3, 4], [5, 6]], dataset.read)
        assert_same(dataset, dataset.append(Numo::Int16.zeros(0, 2)))
        assert_equal([3, 2], dataset.shape)
        assert_raise(HDF5::ConversionError) { dataset.append(Numo::Int64[[7, 8]]) }
        assert_equal([3, 2], dataset.shape)
        assert_raise(HDF5::Error) { dataset.resize([4, 3]) }
      end
    end
  end

  test 'uses the configured fill value for unwritten data' do
    Dir.mktmpdir do |dir|
      path = File.join(dir, 'fillvalue.h5')

      HDF5::File.create(path) do |file|
        dataset = file.create_dataset('values', shape: [3], dtype: :int16, fillvalue: 7)
        assert_equal(7, dataset.fillvalue)
        assert_equal(Numo::Int16[7, 7, 7], dataset.read)
      end
    end
  end

  test 'preserves int64 values on create' do
    Dir.mktmpdir do |dir|
      path = File.join(dir, 'int64-create.h5')

      HDF5::File.create(path) do |file|
        dataset = file.create_dataset('large', [1 << 40])
        assert_equal(Numo::Int64[1 << 40], dataset.read)
      end
    end
  end

  test 'rejects writes with a mismatched shape' do
    Dir.mktmpdir do |dir|
      path = File.join(dir, 'shape-write.h5')

      HDF5::File.create(path) do |file|
        dataset = file.create_dataset('ints', [1, 2, 3])
        assert_raise(HDF5::Error) { dataset.write([1]) }
      end
    end
  end

  test 'block API closes resources automatically' do
    Dir.mktmpdir do |dir|
      path = File.join(dir, 'block.h5')

      HDF5::File.create(path) do |file|
        file.create_group('values') do |group|
          group.create_dataset('ints', [10, 20, 30])
        end
      end

      HDF5::File.open(path) do |file|
        assert_equal(Numo::Int64[10, 20, 30], file['values']['ints'].read)
      end
    end
  end

  test 'closing a file invalidates its child objects' do
    Dir.mktmpdir do |dir|
      path = File.join(dir, 'lifetime.h5')
      file = HDF5::File.create(path)
      group = file.create_group('values')
      dataset = group.create_dataset('ints', [10, 20, 30])
      attrs = dataset.attrs

      file.close

      assert_true(file.closed?)
      assert_true(group.closed?)
      assert_true(dataset.closed?)
      assert_raise(HDF5::ClosedError) { file.keys }
      assert_raise(HDF5::ClosedError) { group.keys }
      assert_raise(HDF5::ClosedError) { dataset.read }
      assert_raise(HDF5::ClosedError) { attrs['unit'] = 'count' }
      assert_nothing_raised do
        dataset.close
        group.close
        file.close
      end
    end
  end

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
    Dir.mktmpdir do |dir|
      path = File.join(dir, 'attribute-numo.h5')

      HDF5::File.create(path) do |file|
        dataset = file.create_dataset('values', [1, 2, 3])
        dataset.attrs['large'] = 1 << 40
        dataset.attrs['matrix'] = Numo::SFloat[[1.5, 2.5], [3.5, 4.5]]
        assert_equal(1 << 40, dataset.attrs['large'])
        assert_equal(Numo::SFloat[[1.5, 2.5], [3.5, 4.5]], dataset.attrs['matrix'])
      end
    end
  end

  test 'group list_datasets returns only datasets' do
    Dir.mktmpdir do |dir|
      path = File.join(dir, 'group-list.h5')

      HDF5::File.create(path) do |file|
        file.create_group('parent') do |parent|
          parent.create_group('child')
          parent.create_dataset('numbers', [1, 2, 3])
        end
      end

      HDF5::File.open(path) do |file|
        parent = file['parent']
        assert_equal(%w[child numbers].sort, parent.list_entries.sort)
        assert_equal(%w[numbers], parent.list_datasets)
      end
    end
  end

  test 'dataset attrs raises HDF5 error for missing attribute' do
    Dir.mktmpdir do |dir|
      path = File.join(dir, 'missing-attribute.h5')

      HDF5::File.create(path) do |file|
        dataset = file.create_dataset('values', [1, 2, 3])
        assert_raise(HDF5::Error) do
          dataset.attrs['does-not-exist']
        end
      ensure
        dataset.close if dataset
      end
    end
  end

  test 'raises HDF5 error for missing file' do
    assert_raise(HDF5::Error) do
      HDF5::File.open('/tmp/does-not-exist-ruby-hdf5.h5')
    end
  end

  test 'supports standard file modes without truncating append mode' do
    Dir.mktmpdir do |dir|
      path = File.join(dir, 'modes.h5')

      HDF5::File.open(path, 'w') { |file| file.create_dataset('original', [1]) }
      HDF5::File.open(path, 'a') { |file| file.create_dataset('appended', [2]) }
      HDF5::File.open(path, 'r') do |file|
        assert_equal(Numo::Int64[1], file['original'].read)
        assert_equal(Numo::Int64[2], file['appended'].read)
      end
      assert_raise(HDF5::Error) { HDF5::File.open(path, 'x') }
      assert_raise(ArgumentError) { HDF5::File.open(path, 'invalid') }
    end
  end

  test 'manages links through common file and group operations' do
    Dir.mktmpdir do |dir|
      path = File.join(dir, 'links.h5')

      HDF5::File.create(path) do |file|
        group = file.create_group('parent')
        group.create_dataset('original', [1])
        assert_equal(['original'], group.keys)
        assert_true(group.key?('original'))
        group.move('original', 'renamed')
        assert_false(group.key?('original'))
        assert_equal(Numo::Int64[1], group['renamed'].read)
        group.create_hard_link('renamed', 'hard-copy')
        group.create_soft_link('/parent/renamed', 'soft-copy')
        group.create_soft_link('/missing', 'broken')
        assert_equal({ type: :hard }, group.link_info('hard-copy'))
        assert_equal({ type: :soft, target: '/parent/renamed' }, group.link_info('soft-copy'))
        assert_equal({ type: :soft, target: '/missing' }, group.link_info('broken'))
        assert_true(group.key?('broken'))
        assert_equal(Numo::Int64[1], group['soft-copy'].read)
        group.delete('renamed').delete('hard-copy').delete('soft-copy').delete('broken')
        assert_false(group.key?('renamed'))
      end
    end
  end

  test 'provides common hierarchy and dataset convenience APIs' do
    Dir.mktmpdir do |dir|
      path = File.join(dir, 'convenience.h5')

      HDF5::File.create(path) do |file|
        group = file.require_group('measurements/nested')
        dataset = group.create_dataset('values', Numo::Int16[[1, 2], [3, 4]])
        assert_equal(2, dataset.ndim)
        assert_equal(4, dataset.size)
        assert_equal([[1, 2], [3, 4]], dataset.read_array)
        assert_equal([1, 2, 3, 4], dataset.read_array(flatten: true))
        assert_equal(['measurements'], file.each_key.to_a)
        group.open_dataset('values') { |opened| assert_equal(dataset.read, opened.read) }
      end
    end
  end

  test 'manages and modifies attributes without replacing their type' do
    Dir.mktmpdir do |dir|
      path = File.join(dir, 'attribute-manager.h5')

      HDF5::File.create(path) do |file|
        attrs = file.create_dataset('values', [1]).attrs
        attrs.create('scale', Numo::Int16.cast(2))
        assert_equal(['scale'], attrs.keys)
        assert_true(attrs.key?('scale'))
        attrs.modify('scale', 4)
        assert_equal(4, attrs['scale'])
        assert_raise(HDF5::Error) { attrs.modify('scale', [1, 2]) }
        assert_raise(HDF5::Error) { attrs.create('scale', 5) }
        assert_same(attrs, attrs.delete('scale'))
        assert_false(attrs.key?('scale'))
      end
    end
  end

  test 'retains a handle when native close fails so close can be retried' do
    context = HDF5::FileContext.new(100)
    context.register(200, :group)
    calls = 0
    replacement = lambda do |_id|
      calls += 1
      calls == 1 ? -1 : 0
    end

    replace_ffi_method(:H5Gclose, replacement) do
      assert_raise(HDF5::Error) { context.close(200) }
      assert_nothing_raised { context.close(200) }
    end
    assert_equal(2, calls)
  end

  test 'supports automatic chunks for variable-length string datasets' do
    Dir.mktmpdir do |dir|
      path = File.join(dir, 'string-chunks.h5')

      HDF5::File.create(path) do |file|
        dataset = file.create_dataset('labels', %w[one two three], chunks: :auto, compression: :gzip)
        assert_equal(%w[one two three], dataset.read.to_a)
        assert_equal([3], dataset.chunks)
      end
    end
  end

  test 'rejects append to a Null dataset with an HDF5 error' do
    Dir.mktmpdir do |dir|
      path = File.join(dir, 'null-append.h5')

      HDF5::File.create(path) do |file|
        dataset = file.create_dataset('null', HDF5::Empty.new(:int16))
        assert_raise(HDF5::Error) { dataset.append(Numo::Int16[1]) }
      end
    end
  end

  test 'removes a newly created dataset when its initial write fails' do
    Dir.mktmpdir do |dir|
      path = File.join(dir, 'failed-create.h5')

      HDF5::File.create(path) do |file|
        replace_ffi_method(:H5Dwrite, ->(*_args) { -1 }) do
          assert_raise(HDF5::Error) { file.create_dataset('partial', [1, 2]) }
        end
        assert_false(file.key?('partial'))
      end
    end
  end

  test 'reports failure to reclaim variable-length string memory' do
    Dir.mktmpdir do |dir|
      path = File.join(dir, 'string-reclaim.h5')

      HDF5::File.create(path) { |file| file.create_dataset('labels', %w[one two]) }
      HDF5::File.open(path) do |file|
        replace_ffi_method(:H5Dvlen_reclaim, ->(*_args) { -1 }) do
          assert_raise(HDF5::Error) { file['labels'].read }
        end
      end
    end
  end
end
