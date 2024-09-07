# frozen_string_literal: true

require 'ffi'
require_relative 'hdf5/version'

module HDF5
  class Error < StandardError; end

  class << self
    attr_accessor :lib_path

    def search_hdf5lib(name = nil)
      return File.expand_path(name, ENV['HDF5_LIB_PATH']) if ENV['HDF5_LIB_PATH']

      name = "libhdf5.#{FFI::Platform::LIBSUFFIX}"

      begin
        require 'pkg-config'
        libs = PKGConfig.libs('hdf5')
        pattern = %r{(?<=-L)/[^ ]+}
        lib_dir = libs.scan(pattern).first
        lib_path = File.expand_path(name, lib_dir)
      rescue PackageConfig::NotFoundError
        warn 'hdf5.pc not found.'
      end
      return lib_path if File.exist?(lib_path)

      warn "htslib shared library '#{name}' not found."
    end
  end

  self.lib_path = search_hdf5lib
end

require_relative 'hdf5/ffi3'
