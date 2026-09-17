# frozen_string_literal: true

require 'fileutils'
require 'hdf5'

filename = 'GLAH01_033_2103_001_1107_3_01_0001.H5'
url = "https://icesat.gsfc.nasa.gov/icesat/hdf5_products/data/#{filename}"
path = File.join(__dir__, 'data', filename)

unless File.file?(path)
  system('curl', '--fail', '--location', '--create-dirs', '--output', path, url) || raise('Download failed')
end

waveform = HDF5::File.open(path) { |file| file['Data_40HZ/Waveform/RecWaveform/r_rng_wf'].read }
waveform[waveform.abs.ge(1_000_000)] = -1
shot_count = waveform.shape[0]
range_bin_count = waveform.shape[1]

output_path = File.join(__dir__, 'output', 'icesat_glas_waveform.png')
FileUtils.mkdir_p(File.dirname(output_path))
edges = Numo::Int64.new(1041).seq * shot_count / 1040
tick_labels = (0..4).map { |index| "'#{index * shot_count / 4}' #{index * 1039 / 4}" }.join(', ')

heatmap = Numo::SFloat.cast(1040.times.map { |i| waveform[edges[i]...edges[i + 1], true].max(0) })
IO.popen('gnuplot', 'w') do |stdin|
  stdin.write <<~GNUPLOT
    set terminal pngcairo size 1200,900
    set output #{output_path.dump}
    set title 'ICESat GLAS returned waveform'; set xlabel 'Shot order'; set ylabel 'Waveform sample index'
    set cblabel 'Received 1064 nm signal (V)'; set xtics (#{tick_labels}); set grid
    set cbrange [0:0.5]; set palette defined (0 'blue', 0.33 'cyan', 0.66 'yellow', 1 'red')
    set yrange [0:#{range_bin_count - 1}] reverse
    plot '-' matrix with image notitle
  GNUPLOT
  heatmap.transpose.to_a.each do |row|
    stdin.puts row.join(' ')
  end
  stdin.puts 'e'
end
