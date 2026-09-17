# frozen_string_literal: true

require 'fileutils'
require 'hdf5'

output_dir = File.expand_path('output', __dir__)
FileUtils.mkdir_p(output_dir)
path = File.join(output_dir, '07_scalar_empty_null.h5')

HDF5::File.open(path, 'w') do |file|
  file.create_dataset('scalar', 42)
  file.create_dataset('empty', shape: [0, 3], dtype: :float32)
  file.create_dataset('missing', HDF5::Empty.new(:int16))
end

HDF5::File.open(path) do |file|
  %w[scalar empty missing].each do |name|
    dataset = file[name]
    puts "#{name}: shape=#{dataset.shape.inspect}, value=#{dataset.read.inspect}"
  end
end
