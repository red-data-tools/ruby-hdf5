# frozen_string_literal: true

require 'fileutils'
require 'hdf5'

output_dir = File.expand_path('output', __dir__)
FileUtils.mkdir_p(output_dir)
path = File.join(output_dir, '02_groups_and_paths.h5')

HDF5::File.open(path, 'w') do |file|
  run = file.require_group('experiments/run_001')
  run.create_dataset('temperature', [21.1, 21.4, 21.8])
end

HDF5::File.open(path) do |file|
  dataset = file['experiments/run_001/temperature']
  puts "Root entries: #{file.keys.inspect}"
  puts "Values: #{dataset.read.inspect}"
end
