# frozen_string_literal: true

require_relative 'test_helper'

class HDF5FileTest < Test::Unit::TestCase
  test 'raises NativeError for a missing file' do
    with_path do |path|
      assert_raise(HDF5::NativeError) { HDF5::File.open(path) }
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
      assert_raise(HDF5::NativeError) { HDF5::File.open(path, 'x') }
      assert_raise(ArgumentError) { HDF5::File.open(path, 'invalid') }
    end
  end
end
