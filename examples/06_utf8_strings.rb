# frozen_string_literal: true

require 'fileutils'
require 'hdf5'

output_dir = File.expand_path('output', __dir__)
FileUtils.mkdir_p(output_dir)
path = File.join(output_dir, '06_utf8_strings.h5')

HDF5::File.open(path, 'w') do |file|
  file.create_dataset('greeting', 'hello, Ruby')
  labels = file.create_dataset('labels', [%w[alpha 日本語], %w[gamma delta]])
  labels.attrs['language'] = 'UTF-8'
  file.create_dataset('empty_labels', [], dtype: :string)
  file.create_dataset('empty_matrix', shape: [0, 3], dtype: :string)
  file.create_dataset('missing_label', HDF5::Empty.new(:string))
  file.attrs.create('empty_labels', [], dtype: :string)
  file.attrs['missing_label'] = HDF5::Empty.new(:string)
end

HDF5::File.open(path) do |file|
  puts "greeting: #{file['greeting'].read}"
  puts "labels: #{file['labels'].read.to_a.inspect}"
  puts "encoding: #{file['labels'].attrs['language']}"
  puts "empty labels shape: #{file['empty_labels'].read.shape.inspect}"
  puts "empty matrix shape: #{file['empty_matrix'].read.shape.inspect}"
  puts "missing label dtype: #{file['missing_label'].read.dtype.to_sym}"
end
