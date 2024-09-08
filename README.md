# ruby-hdf5

[![test](https://github.com/kojix2/c2ffi4rb/actions/workflows/ci.yml/badge.svg)](https://github.com/kojix2/c2ffi4rb/actions/workflows/ci.yml)

experimental Ruby bindings for the HDF5 library

## Development

- [c2ffi](https://github.com/rpav/c2ffi)
- [c2ffi4rb](https://github.com/kojix2/c2ffi4rb)

### Generate spec file

```sh
c2ffi $(pkg-config --cflags-only-I hdf5 | ruby -npe '$_.strip!.gsub!(/-I/, "")<<"/hdf5.h"') > hdf5.json
# c2ffi /usr/include/hdf5/serial/hdf5.h > hdf5.json
```

### Generate Ruby bindings

```sh
c2ffi4rb hdf5.json > lib/hdf5/ffi.rb
```

The auto-generated bindings require some minor manual modifications, see the end of the ffi3.rb file.

### HDF5 1.10 or 1.14

Compatibility issues between versions of HDF5

Several functions in HDF5 are incompatible between 1.10 and 1.14 (the latest version at the time of writing). The current version of ruby-hdf5 is compliant with 1.10. This is because the latest version of the Ubuntu package is 1.10. However, 1.14 is already distributed with homebrew and 1.10 will be removed during 2025. It will need to be rewritten for 1.14 in the near future.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
