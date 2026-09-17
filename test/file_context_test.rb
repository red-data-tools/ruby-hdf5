# frozen_string_literal: true

require_relative 'test_helper'

class FileContextTest < Test::Unit::TestCase
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

  test 'retains a handle when native close fails so close can be retried' do
    context = HDF5::FileContext.new(100)
    context.register(200, :group)
    calls = 0
    replacement = lambda do |_id|
      calls += 1
      calls == 1 ? -1 : 0
    end

    replace_ffi_method(:H5Gclose, replacement) do
      assert_raise(HDF5::NativeError) { context.close(200) }
      assert_nothing_raised { context.close(200) }
    end
    assert_equal(2, calls)
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

  {
    group: [:H5Gclose, ->(file) { file.create_group('values'); HDF5::Group.new(file.send(:hdf5_id), 'values') }, :keys],
    dataset: [:H5Dclose, ->(file) {
      file.create_dataset('values', [1]); HDF5::Dataset.new(file.send(:hdf5_id), 'values')
    }, :read],
    attribute: [:H5Aclose, ->(file) {
      file.attrs['value'] = 1; HDF5::Attribute.new(file.send(:hdf5_id), 'value')
    }, :read]
  }.each do |name, (function, open_object, operation)|
    test "standalone #{name} handles remain usable and close can be retried after failure" do
      with_file do |file|
        object = open_object.call(file)
        begin
          replace_ffi_method(function, ->(*) { -1 }) do
            assert_raise(HDF5::NativeError) { object.close }
            assert_nothing_raised { object.public_send(operation) }
          end
          assert_nothing_raised { object.close }
          assert_raise(HDF5::ClosedError) { object.public_send(operation) }
          assert_nothing_raised { object.close }
        ensure
          object.close
        end
      end
    end
  end

  {
    group: [:H5Gclose, ->(file, &block) { file.create_group('values', &block) }],
    dataset: [:H5Dclose, ->(file, &block) { file.create_dataset('values', [1], &block) }],
    open_dataset: [:H5Dclose, ->(file, &block) {
      file.create_dataset('values', [1]); file.open_dataset('values', &block)
    }]
  }.each do |name, (function, operation)|
    test "#{name} blocks preserve user exceptions when close also fails" do
      with_file do |file|
        user_error = RuntimeError.new('user calculation failed')
        opened = nil
        replace_ffi_method(function, ->(*) { -1 }) do
          error = assert_raise(RuntimeError) do
            operation.call(file) { |object| opened = object; raise user_error }
          end
          assert_same(user_error, error)
        end
        assert_false(opened.closed?)
        opened.close
        assert_true(opened.closed?)
      end
    end

    test "#{name} blocks report close failures after a successful user block" do
      with_file do |file|
        opened = nil
        replace_ffi_method(function, ->(*) { -1 }) do
          assert_raise(HDF5::NativeError) { operation.call(file) { |object| opened = object; :result } }
        end
        opened.close
        assert_true(opened.closed?)
      end
    end
  end

  %i[create open].each do |operation|
    test "file #{operation} blocks preserve user exceptions when close also fails" do
      with_path do |path|
        HDF5::File.create(path).close if operation == :open
        opened = nil
        user_error = RuntimeError.new('user calculation failed')
        replace_ffi_method(:H5Fclose, ->(*) { -1 }) do
          error = assert_raise(RuntimeError) do
            HDF5::File.public_send(operation, path) { |file| opened = file; raise user_error }
          end
          assert_same(user_error, error)
        end
        opened.close
        assert_true(opened.closed?)
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
