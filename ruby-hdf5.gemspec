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

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|circleci)|appveyor)})
    end
  end
  spec.require_paths = ['lib']

  spec.add_dependency 'ffi'
  spec.add_dependency 'pkg-config'

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
