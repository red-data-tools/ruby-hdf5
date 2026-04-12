require 'hdf5'

begin
  HDF5::File.open('/tmp/does-not-exist-ruby-hdf5.h5')
rescue HDF5::Error => e
  warn "HDF5::Error: #{e.message}"
end

begin
  HDF5::File.create(File.expand_path('bad_data.h5', __dir__)) do |file|
    file.create_dataset('invalid', %w[a b c])
  end
rescue HDF5::Error => e
  warn "HDF5::Error: #{e.message}"
end
