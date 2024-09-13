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

The auto-generated bindings require some minor manual modifications.

### 　Development Strategy

#### All pull requests will be merged

- All pull requests received will be merged unless there is detrimental code.
- If the pull request contains a bug, it still will be merged.
- The author can add a commit to the pull request or send another pull request to fix the bug later.

#### Why are all pull requests merged?

- We prioritise the sustainable development or maintainance of the projects over keeping high code quality.
- High code quality is important to keep developers and users motivated.
- However, it is a historical fact that the HDF5 binding has not been created and maintained by the Ruby community for a long time.
- This situation of extremely low developer density requires unusual strategies to maintain the project.

## Acknowledgement

[https://github.com/edmundhighcock/hdf5](https://github.com/edmundhighcock/hdf5)

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
