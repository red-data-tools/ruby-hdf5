require 'fileutils'
require 'hdf5'

output_dir = File.expand_path('output', __dir__)
FileUtils.mkdir_p(output_dir)
path = File.join(output_dir, '15_growing_datasets.h5')

HDF5::File.open(path, 'w') do |file|
  samples = file.create_dataset('samples', shape: [0, 2], dtype: :int16, maxshape: [nil, 2], chunks: [2, 2])
  samples.append(Numo::Int16[[1, 2], [3, 4]])
  samples.append(Numo::Int16[[5, 6]])
  puts "shape after append: #{samples.shape.inspect}"
end

HDF5::File.open(path) { |file| puts "values: #{file['samples'].read.to_a.inspect}" }