require 'fileutils'
require 'hdf5'

output_dir = File.expand_path('output', __dir__)
FileUtils.mkdir_p(output_dir)
path = File.join(output_dir, '09_writing_slices.h5')

HDF5::File.open(path, 'w') do |file|
  matrix = file.create_dataset('matrix', Numo::Int16.zeros(3, 3))
  matrix[1, true] = Numo::Int16[10, 11, 12]
  matrix.write(-1, selection: [0, 1..])
end

HDF5::File.open(path) { |file| puts file['matrix'].read.to_a.inspect }