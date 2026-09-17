# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path('../lib', __dir__)
require 'hdf5'

require 'test-unit'

module HDF5TestHelpers
  def replace_ffi_method(name, replacement)
    singleton_class = HDF5::FFI.singleton_class
    original = HDF5::FFI.method(name).super_method
    raise "Cannot replace FFI method: #{name}" unless original

    singleton_class.define_method(name, &replacement)
    yield
  ensure
    singleton_class.define_method(name, original) if original
  end
end

Test::Unit::TestCase.include(HDF5TestHelpers)
