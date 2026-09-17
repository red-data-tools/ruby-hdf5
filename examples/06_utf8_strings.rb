require 'fileutils'
require 'hdf5'

output_dir = File.expand_path('output', __dir__)
FileUtils.mkdir_p(output_dir)
path = File.join(output_dir, '06_utf8_strings.h5')

HDF5::File.open(path, 'w') do |file|
  file.create_dataset('greeting', 'hello, Ruby')
  labels = file.create_dataset('labels', [['alpha', '日本語'], ['gamma', 'delta']])
  labels.attrs['language'] = 'UTF-8'
end

HDF5::File.open(path) do |file|
  puts "greeting: #{file['greeting'].read}"
  puts "labels: #{file['labels'].read.to_a.inspect}"
  puts "encoding: #{file['labels'].attrs['language']}"
end