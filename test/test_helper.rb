# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path('../lib', __dir__)
require 'hdf5'

require 'test-unit'
require 'tmpdir'

module HDF5TestHelpers
  def with_file
    Dir.mktmpdir do |dir|
      HDF5::File.create(File.join(dir, 'test.h5')) { |file| yield file }
    end
  end

  def with_path
    Dir.mktmpdir { |dir| yield File.join(dir, 'test.h5') }
  end

  def replace_ffi_method(name, replacement)
    singleton_class = HDF5::FFI.singleton_class
    original = HDF5::FFI.method(name).super_method
    raise "Cannot replace FFI method: #{name}" unless original

    singleton_class.remove_method(name)
    singleton_class.define_method(name, &replacement)
    yield
  ensure
    if original
      singleton_class.remove_method(name)
      singleton_class.define_method(name, original)
    end
  end

  private :with_file, :with_path, :replace_ffi_method
end

Test::Unit::TestCase.include(HDF5TestHelpers)
