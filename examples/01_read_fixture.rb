require 'hdf5'

fixture = File.expand_path('../test/fixtures/example.h5', __dir__)

HDF5::File.open(fixture) do |file|
  puts "Entries: #{file.list_entries.inspect}"

  group = file['foo']
  puts "Datasets in /foo: #{group.list_datasets.inspect}"

  int_ds = group['bar_int']
  puts "bar_int shape: #{int_ds.shape.inspect}"
  puts "bar_int dtype: #{int_ds.dtype}"
  puts "bar_int values: #{int_ds.read.inspect}"
end
