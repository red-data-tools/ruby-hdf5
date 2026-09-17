# frozen_string_literal: true

require 'fileutils'
require 'hdf5'

output_dir = File.expand_path('output', __dir__)
FileUtils.mkdir_p(output_dir)
path = File.join(output_dir, '20_file_modes_and_errors.h5')

HDF5::File.open(path, 'w') { |file| file.create_dataset('original', [1]) }
HDF5::File.open(path, 'a') { |file| file.create_dataset('appended', [2]) }

HDF5::File.open(path, 'r') do |file|
  puts "entries after append: #{file.keys.inspect}"
end

begin
  HDF5::File.open(path, 'x')
rescue HDF5::Error => e
  warn "exclusive create failed: #{e.message}"
end
