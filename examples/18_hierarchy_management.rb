require 'fileutils'
require 'hdf5'

output_dir = File.expand_path('output', __dir__)
FileUtils.mkdir_p(output_dir)
path = File.join(output_dir, '18_hierarchy_management.h5')

HDF5::File.open(path, 'w') do |file|
  group = file.require_group('measurements/processed')
  group.create_dataset('mean', Numo::SFloat[1.0, 2.0])
  puts "root keys: #{file.each_key.to_a.inspect}"
  group.open_dataset('mean') { |dataset| puts "mean: #{dataset.read.to_a.inspect}" }
end