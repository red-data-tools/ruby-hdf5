require 'hdf5'

path = File.expand_path('nested_groups.h5', __dir__)

HDF5::File.create(path) do |file|
  file.create_group('experiments') do |experiments|
    experiments.create_group('run_001') do |run|
      run.create_dataset('temperatures', [21.1, 21.3, 21.7, 22.0])
    end
  end
end

HDF5::File.open(path) do |file|
  run = file['experiments']['run_001']
  ds = run['temperatures']

  puts "Dataset shape: #{ds.shape.inspect}"
  puts "Dataset dtype: #{ds.dtype}"
  puts "Dataset values: #{ds.read.inspect}"
end
