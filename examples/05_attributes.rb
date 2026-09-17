# frozen_string_literal: true

require 'fileutils'
require 'hdf5'

output_dir = File.expand_path('output', __dir__)
FileUtils.mkdir_p(output_dir)
path = File.join(output_dir, '05_attributes.h5')

HDF5::File.open(path, 'w') do |file|
  group = file.create_group('measurements')
  dataset = group.create_dataset('signal', Numo::SFloat[0.1, 0.2, 0.3])
  file.attrs['creator'] = 'ruby-hdf5'
  group.attrs['instrument'] = 'sensor-a'
  dataset.attrs['unit'] = 'V'
end

HDF5::File.open(path) do |file|
  dataset = file['measurements/signal']
  puts "creator: #{file.attrs['creator']}"
  puts "instrument: #{file['measurements'].attrs['instrument']}"
  puts "unit: #{dataset.attrs['unit']}"
end
