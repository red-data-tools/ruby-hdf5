# ruby-hdf5

[![test](https://github.com/red-data-tools/ruby-hdf5/actions/workflows/test.yml/badge.svg)](https://github.com/red-data-tools/ruby-hdf5/actions/workflows/test.yml)

Ruby bindings for the HDF5 library.

## Scope

This gem currently provides practical high-level wrappers for:

- opening and creating files
- creating and traversing groups
- multidimensional Numo numeric datasets and attributes
- scalar, zero-length, and Null dataspaces
- hyperslab reads and writes, block iteration, and chunk iteration
- chunked storage, gzip, shuffle, Fletcher32, resize, and append
- variable-length UTF-8 scalar and array datasets and attributes
- h5py-compatible bool and complex datatypes

Unsupported at this stage:

- fixed-length strings and explicit string encoding options
- general compound, enum, reference, and variable-length numeric types
- fancy indexing, boolean masks, negative slice steps, and general broadcasting
- SWMR, MPI, and VDS creation

`Group#list_datasets` filters datasets from group entries by checking object type per entry.
For very large groups, this may be slower than `Group#list_entries`.

## HDF5 Versions

The current implementation is tested with HDF5 1.10.10 on Linux. HDF5 1.14,
macOS, and Windows are planned compatibility targets but are not verified by
the current test environment. Unknown major versions are not treated as
compatible automatically.

HDF5 versions older than 1.10 are not supported.

## Install

Add to your Gemfile:

```ruby
gem 'ruby-hdf5'
```

Install:

```sh
bundle install
```

System library (`libhdf5`) is required.

## Runtime Notes

- The gem loads `libhdf5` through FFI.
- If the shared library cannot be found automatically, set `HDF5_LIB_PATH`.

Examples:

```sh
# Point to a directory containing libhdf5.so
export HDF5_LIB_PATH=/usr/lib

# Or point directly to the shared object
export HDF5_LIB_PATH=/usr/lib/libhdf5.so
```

## Quick Start

### Read an existing file

```ruby
require 'hdf5'

HDF5::File.open('example.h5') do |file|
  dataset = file['foo/bar_int']
  p dataset.shape
  p dataset.dtype.to_sym
  p dataset.read
end
```

### Create and write a file

```ruby
require 'hdf5'

HDF5::File.create('numbers.h5') do |file|
	matrix = Numo::SFloat.new(100, 64).seq
	dataset = file.require_group('measurements').create_dataset(
		'signal',
		matrix,
		chunks: :auto,
		compression: :gzip
	)
	dataset.attrs['unit'] = 'a.u.'
	dataset[0...10, true] = Numo::SFloat.zeros(10, 64)
end

reopened = HDF5::File.open('numbers.h5')
p reopened['values']['ints'].read
reopened.close
```

## Error Handling

High-level API failures raise `HDF5::Error`.

```ruby
begin
  HDF5::File.open('missing.h5')
rescue HDF5::Error => e
  warn e.message
end
```

## Development

After more than a decade, it is clear that the Ruby community does not have enough resources to sustainably maintain an HDF5 library. For that reason, development of this library is intentionally AI-assisted. Something is better than nothing.

## Acknowledgement

[https://github.com/edmundhighcock/hdf5](https://github.com/edmundhighcock/hdf5)

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
