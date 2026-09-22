# ruby-hdf5

[![test](https://github.com/red-data-tools/ruby-hdf5/actions/workflows/test.yml/badge.svg)](https://github.com/red-data-tools/ruby-hdf5/actions/workflows/test.yml)
[![Gem Version](https://badge.fury.io/rb/ruby-hdf5.svg)](https://badge.fury.io/rb/ruby-hdf5)
[![Lines of Code](https://img.shields.io/endpoint?url=https%3A%2F%2Ftokei.kojix2.net%2Fbadge%2Fgithub%2Fred-data-tools%2Fruby-hdf5%2Flines)](https://tokei.kojix2.net/github/red-data-tools/ruby-hdf5)

Ruby bindings for [HDF5](https://github.com/red-data-tools/ruby-hdf5) with [Numo::NArray](https://github.com/yoshoku/numo-narray-alt) support.

## Requirements

- Ruby 3.4 or later
- HDF5 1.10 or later (`libhdf5` shared library)

## Install

Add the gem to your Gemfile:

```ruby
gem 'ruby-hdf5'
```

Then install dependencies:

```sh
bundle install
```

Set `HDF5_LIB_PATH` only when `libhdf5` cannot be found automatically. It may be a library directory or a shared-library path.

```sh
export HDF5_LIB_PATH=/usr/lib/libhdf5.so
```

## Usage

Create a file and write a Numo array:

```ruby
require 'hdf5'

matrix = Numo::SFloat.new(100, 64).seq

HDF5::File.open('numbers.h5', 'w') do |file|
	dataset = file.require_group('measurements').create_dataset('signal', matrix)
	dataset.attrs['unit'] = 'a.u.'
end
```

Read data and inspect its type:

```ruby
HDF5::File.open('numbers.h5') do |file|
	dataset = file['measurements/signal']
	p dataset.shape
	p dataset.dtype.to_sym
	p dataset.read
end
```

Use a block with `HDF5::File.open` to close the file automatically. Supported modes are `r`, `r+`, `w`, `x`, and `a`.

## Common Tasks

Read a row, a column, or a strided selection without reading the complete dataset:

```ruby
HDF5::File.open('numbers.h5') do |file|
	dataset = file['measurements/signal']
	row = dataset[10, true]
	column = dataset[true, 0]
	every_tenth_row = dataset[HDF5.slice(0...100, step: 10), true]
end
```

Append rows to an extendible dataset. Extendible datasets must use chunked storage:

```ruby
HDF5::File.open('samples.h5', 'w') do |file|
	samples = file.create_dataset(
		'samples',
		shape: [0, 2],
		dtype: :float32,
		maxshape: [nil, 2],
		chunks: [256, 2]
	)
	samples.append(Numo::SFloat[[1.0, 2.0], [3.0, 4.0]])
end
```

Process a dataset in bounded-memory blocks:

```ruby
sum = 0.0

HDF5::File.open('numbers.h5') do |file|
	file['measurements/signal'].each_block(max_bytes: 4 * 1024 * 1024) do |_selection, block|
		sum += block.sum
	end
end
```

## Main Operations

- Hierarchy: `[]`, `create_group`, `require_group`, `keys`, `delete`, `move`
- Datasets: `create_dataset`, `read`, `write`, `[]`, `[]=`, `read_into`
- Dataset metadata: `shape`, `ndim`, `size`, `dtype`, `chunks`, `maxshape`, `fillvalue`
- Storage: chunking, gzip, shuffle, Fletcher32, resize, and append
- Iteration: `each_block(max_bytes:)` and `each_chunk`
- Attributes: `attrs[]`, `attrs[]=`, `attrs.create`, `attrs.write`, `attrs.modify`, `attrs.delete`

Datasets support Numo numeric arrays, scalar values, variable-length UTF-8 strings, h5py-compatible bool values, and h5py-compatible complex values.

Use `dtype: :string` for empty string arrays and `HDF5::Empty.new(:string)` for Null strings.

## Limitations

- Fixed-length strings, general compound / enum / reference types, and variable-length numeric types are unsupported.
- Fancy indexing, boolean masks, negative slice steps, and general broadcasting are unsupported.
- SWMR, MPI, and VDS creation are unsupported.

## Examples

See [examples/README.md](examples/README.md) for standalone examples, ordered from basic file I/O through chunking, resizing, and links.

## License

MIT. See [LICENSE.txt](LICENSE.txt).
