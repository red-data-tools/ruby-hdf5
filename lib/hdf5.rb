# frozen_string_literal: true

require 'ffi'
require_relative 'hdf5/version'

module HDF5
  class Error < StandardError; end

  class << self
    attr_accessor :lib_path

    def search_hdf5lib
      name = "libhdf5.#{FFI::Platform::LIBSUFFIX}"
      env_path = ENV['HDF5_LIB_PATH']
      return env_path if env_path && File.file?(env_path)
      return File.expand_path(name, env_path) if env_path && File.directory?(env_path)

      begin
        require 'pkg-config'
        libs = PKGConfig.libs('hdf5')
        pattern = %r{(?<=-L)/[^ ]+}
        libs.scan(pattern).each do |lib_dir|
          lib_path = File.expand_path(name, lib_dir)
          return lib_path if File.exist?(lib_path)
        end
      rescue PackageConfig::NotFoundError
        warn 'hdf5.pc not found.'
      end

      name
    end
  end

  self.lib_path = search_hdf5lib
end

require_relative 'hdf5/ffi'

require_relative 'hdf5/file'
require_relative 'hdf5/group'
require_relative 'hdf5/dataset'
require_relative 'hdf5/attribute'
