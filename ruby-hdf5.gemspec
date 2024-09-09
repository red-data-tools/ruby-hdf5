# frozen_string_literal: true

require_relative 'lib/hdf5/version'

Gem::Specification.new do |spec|
  spec.name = 'ruby-hdf5'
  spec.version = HDF5::VERSION
  spec.authors = ['kojix2']
  spec.email = ['2xijok@gmail.com']

  spec.summary = 'hdf5'
  spec.description = 'hdf5'
  spec.license = 'MIT'
  spec.required_ruby_version = '>= 3.2.0'

  spec.files         = Dir["*.{md,txt}", "{lib}/**/*", "vendor/*.{so,dylib,dll}"]
  spec.require_path  = "lib"
  spec.require_paths = ['lib']

  spec.add_dependency 'ffi'
  spec.add_dependency 'pkg-config'

  spec.metadata["msys2_mingw_dependencies"] = "hdf5"
end
