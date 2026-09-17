# frozen_string_literal: true

require 'fileutils'
require 'hdf5'

output_dir = File.expand_path('output', __dir__)
FileUtils.mkdir_p(output_dir)
path = File.join(output_dir, '12_boolean_and_complex.h5')

HDF5::File.open(path, 'w') do |file|
  file.create_dataset('enabled', Numo::Bit[1, 0, 1])
  file.create_dataset('spectrum', Numo::DComplex[Complex(1, 2), Complex(3, 4)])
end

HDF5::File.open(path) do |file|
  puts "enabled: #{file['enabled'].read.to_a.inspect}"
  puts "spectrum: #{file['spectrum'].read.to_a.inspect}"
end
