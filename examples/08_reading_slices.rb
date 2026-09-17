# frozen_string_literal: true

require 'fileutils'
require 'hdf5'

output_dir = File.expand_path('output', __dir__)
FileUtils.mkdir_p(output_dir)
path = File.join(output_dir, '08_reading_slices.h5')
matrix = Numo::Int16.new(4, 4).seq

HDF5::File.open(path, 'w') { |file| file.create_dataset('matrix', matrix) }

HDF5::File.open(path) do |file|
  dataset = file['matrix']
  puts "row 1: #{dataset[1, true].to_a.inspect}"
  puts "last column: #{dataset[true, -1].to_a.inspect}"
  puts "every other row: #{dataset[HDF5.slice(0...4, step: 2), true].to_a.inspect}"
end
