require 'fileutils'
require 'hdf5'

output_dir = File.expand_path('output', __dir__)
FileUtils.mkdir_p(output_dir)
path = File.join(output_dir, '10_read_into_existing_array.h5')
matrix = Numo::Int16.new(3, 3).seq

HDF5::File.open(path, 'w') { |file| file.create_dataset('matrix', matrix) }

HDF5::File.open(path) do |file|
  destination = Numo::Int16.zeros(2, 3)
  file['matrix'].read_into(destination, selection: [1.., true])
  puts "reused destination: #{destination.to_a.inspect}"
end