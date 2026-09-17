# ICESat GLAS

Downloads NASA's public GLAH01 sample and writes a PNG waveform heatmap.

```sh
bundle exec ruby -Ilib examples/nasa/icesat_glas.rb
```

Requires `curl` and `gnuplot`. Downloaded data and output are ignored by Git.

Source: [NASA ICESat GLAS HDF5 Sample Data](https://icesat.gsfc.nasa.gov/icesat/hdf5_products/data/index.php).

Do not commit NASA data, documentation, figures, or insignia. Cite the data
source and do not imply NASA endorsement.
