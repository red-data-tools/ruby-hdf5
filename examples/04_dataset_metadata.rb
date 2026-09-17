require 'fileutils'
require 'hdf5'

output_dir = File.expand_path('output', __dir__)
FileUtils.mkdir_p(output_dir)
path = File.join(output_dir, '04_dataset_metadata.h5')

HDF5::File.open(path, 'w') do |file|
  file.create_dataset('samples', shape: [4, 3], dtype: :int16, chunks: [2, 3], fillvalue: -1)
end

HDF5::File.open(path) do |file|
  dataset = file['samples']
  puts "shape: #{dataset.shape.inspect}, ndim: #{dataset.ndim}, size: #{dataset.size}"
  puts "dtype: #{dataset.dtype.to_sym}, chunks: #{dataset.chunks.inspect}, fillvalue: #{dataset.fillvalue}"
end