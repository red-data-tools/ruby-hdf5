require 'hdf5'

path = File.expand_path('numeric_example.h5', __dir__)

HDF5::File.create(path) do |file|
  file.create_group('values') do |group|
    group.create_dataset('ints', [1, 2, 3, 4, 5])
    group.create_dataset('floats', [1.25, 2.5, 3.75])
  end
end

HDF5::File.open(path) do |file|
  puts "Created file: #{path}"
  puts "Root entries: #{file.list_entries.inspect}"

  values = file['values']
  puts "ints: #{values['ints'].read.inspect}"
  puts "floats: #{values['floats'].read.inspect}"
end
