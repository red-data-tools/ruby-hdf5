require 'fileutils'
require 'hdf5'

output_dir = File.expand_path('output', __dir__)
FileUtils.mkdir_p(output_dir)
path = File.join(output_dir, '01_hello_hdf5.h5')

HDF5::File.open(path, 'w') do |file|
  file.create_dataset('numbers', [10, 20, 30])
end

HDF5::File.open(path) do |file|
  dataset = file['numbers']
  puts "Created: #{path}"
  puts "shape: #{dataset.shape.inspect}"
  puts "values: #{dataset.read.inspect}"
end