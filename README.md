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

### Pull Request Review and Merge

The HDF5 Ruby bindings have not been created or maintained for a long time. This means there are very few people in the Ruby community who can create or maintain these bindings. In other words, the history shows that the Ruby community does not have enough time and resources to keep ruby-hdf5 at a high quality.

Because of this situation, we have set the review standards for pull requests **very low** in this project. Specifically, we will **always** merge a pull request unless it contains harmful changes. Even if there are small bugs, we will merge it as long as there are no serious issues. This is because the author can send more pull requests to fix the bugs later. If we don’t merge, nothing will move forward. The time and effort to write and test code are very valuable.

In this project, we do not focus on keeping the code perfectly clean and bug-free. This may seem unusual for a library like HDF5, which handles numbers and data. But the common quality-first approach approach only works when there are enough developers and time. We intentionally avoid this in ruby-hdf5.

In ruby-hdf5, we focus more on keeping the project alive than making the code perfect at a certain point. Like how different organisms adapt to different light environments, the development strategy should change based on the community’s situation.

## Acknowledgement

https://github.com/edmundhighcock/hdf5

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
