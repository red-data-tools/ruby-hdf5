require 'fileutils'
require 'hdf5'

output_dir = File.expand_path('output', __dir__)
FileUtils.mkdir_p(output_dir)
path = File.join(output_dir, '13_chunked_storage.h5')

HDF5::File.open(path, 'w') do |file|
  data = Numo::SFloat.new(100, 16).seq
  file.create_dataset('manual', data, chunks: [25, 16])
  file.create_dataset('automatic', data, chunks: :auto)
end

HDF5::File.open(path) do |file|
  puts "manual chunks: #{file['manual'].chunks.inspect}"
  puts "automatic chunks: #{file['automatic'].chunks.inspect}"
end