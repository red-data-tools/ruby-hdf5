# ruby-hdf5

[![test](https://github.com/red-data-tools/ruby-hdf5/actions/workflows/test.yml/badge.svg)](https://github.com/red-data-tools/ruby-hdf5/actions/workflows/test.yml)

Ruby bindings for the HDF5 library.

## Scope

This gem currently provides practical high-level wrappers for:

- opening and creating files
- creating groups
- creating, writing, and reading one-dimensional numeric datasets
- reading and writing numeric attributes

Unsupported at this stage:

- string dataset read/write
- multidimensional array write

Integer datasets and integer attributes currently use native C `int` under the hood.
Values outside that range are rejected with `HDF5::Error` to avoid silent overflow.

`Group#list_datasets` filters datasets from group entries by checking object type per entry.
For very large groups, this may be slower than `Group#list_entries`.

## Supported HDF5 Versions

- HDF5 1.10
- HDF5 1.14
- HDF5 2.x

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
	group = file['foo']
	dataset = group['bar_int']
	p dataset.shape
	p dataset.dtype
	p dataset.read
end
```

### Create and write a file

```ruby
require 'hdf5'

HDF5::File.create('numbers.h5') do |file|
	file.create_group('values') do |group|
		group.create_dataset('ints', [1, 2, 3, 4])
	end
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
