# frozen_string_literal: true

require 'fileutils'
require 'hdf5'

output_dir = File.expand_path('output', __dir__)
FileUtils.mkdir_p(output_dir)
path = File.join(output_dir, '14_filters_and_integrity.h5')
data = Numo::Int16.new(100, 8).seq

HDF5::File.open(path, 'w') do |file|
  file.create_dataset('samples', data, chunks: [25, 8], compression: :gzip, compression_opts: 4,
                                       shuffle: true, fletcher32: true)
end

HDF5::File.open(path) do |file|
  dataset = file['samples']
  puts "chunks: #{dataset.chunks.inspect}"
  puts "first row: #{dataset[0, true].to_a.inspect}"
end
