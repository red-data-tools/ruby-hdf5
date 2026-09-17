require 'fileutils'
require 'hdf5'

output_dir = File.expand_path('output', __dir__)
FileUtils.mkdir_p(output_dir)
path = File.join(output_dir, '19_links.h5')

HDF5::File.open(path, 'w') do |file|
  group = file.create_group('data')
  group.create_dataset('original', [1, 2, 3])
  group.create_hard_link('original', 'hard_copy')
  group.create_soft_link('/data/original', 'soft_copy')
  puts "hard: #{group.link_info('hard_copy').inspect}"
  puts "soft: #{group.link_info('soft_copy').inspect}"
  puts "soft values: #{group['soft_copy'].read.to_a.inspect}"
end