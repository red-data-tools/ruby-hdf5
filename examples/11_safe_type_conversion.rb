# frozen_string_literal: true

require 'fileutils'
require 'hdf5'

output_dir = File.expand_path('output', __dir__)
FileUtils.mkdir_p(output_dir)
path = File.join(output_dir, '11_safe_type_conversion.h5')

HDF5::File.open(path, 'w') { |file| file.create_dataset('integers', Numo::Int16[1, 2, 3]) }

HDF5::File.open(path, 'r+') do |file|
  dataset = file['integers']
  puts "float32: #{dataset.read(dtype: :float32).to_a.inspect}"
  dataset.write(Numo::Int64[4, 5, 6], casting: :unsafe)
  puts "after unsafe write: #{dataset.read.to_a.inspect}"
end
