require 'fileutils'
require 'hdf5'

output_dir = File.expand_path('output', __dir__)
FileUtils.mkdir_p(output_dir)
path = File.join(output_dir, '17_processing_chunks.h5')
data = Numo::Int16.new(3, 3).seq

HDF5::File.open(path, 'w') { |file| file.create_dataset('matrix', data, chunks: [2, 2]) }

HDF5::File.open(path) do |file|
  file['matrix'].each_chunk do |selection, chunk|
    puts "#{selection.inspect}: #{chunk.to_a.inspect}"
  end
end