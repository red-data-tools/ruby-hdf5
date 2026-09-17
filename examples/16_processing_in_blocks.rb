# frozen_string_literal: true

require 'fileutils'
require 'hdf5'

output_dir = File.expand_path('output', __dir__)
FileUtils.mkdir_p(output_dir)
path = File.join(output_dir, '16_processing_in_blocks.h5')
data = Numo::Int16.new(12, 4).seq

HDF5::File.open(path, 'w') { |file| file.create_dataset('samples', data) }

HDF5::File.open(path) do |file|
  total = 0
  file['samples'].each_block(max_bytes: 32) { |_selection, block| total += block.sum }
  puts "sum: #{total}"
end
