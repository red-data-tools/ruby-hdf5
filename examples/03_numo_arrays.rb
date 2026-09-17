# frozen_string_literal: true

require 'fileutils'
require 'hdf5'

output_dir = File.expand_path('output', __dir__)
FileUtils.mkdir_p(output_dir)
path = File.join(output_dir, '03_numo_arrays.h5')
matrix = Numo::SFloat[[1.5, 2.5], [3.5, 4.5]]

HDF5::File.open(path, 'w') { |file| file.create_dataset('matrix', matrix) }

HDF5::File.open(path) do |file|
  dataset = file['matrix']
  puts "dtype: #{dataset.dtype.to_sym}"
  puts "shape: #{dataset.shape.inspect}"
  puts "values: #{dataset.read.to_a.inspect}"
end
