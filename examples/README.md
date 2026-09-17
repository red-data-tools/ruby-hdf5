# Examples

Run an individual example from the repository root:

```sh
bundle exec ruby -Ilib examples/01_hello_hdf5.rb
```

Run the complete sequence:

```sh
bundle exec rake test:examples
```

Each script creates its own file under `examples/output/`.

1. `01_hello_hdf5.rb`: create and read a numeric dataset
2. `02_groups_and_paths.rb`: create groups and access paths
3. `03_numo_arrays.rb`: store multidimensional Numo arrays
4. `04_dataset_metadata.rb`: inspect dataset metadata
5. `05_attributes.rb`: attach metadata to files, groups, and datasets
6. `06_utf8_strings.rb`: store UTF-8 strings, explicit empty arrays, and Null strings
7. `07_scalar_empty_null.rb`: distinguish scalar, empty, and Null dataspaces
8. `08_reading_slices.rb`: read dataset selections
9. `09_writing_slices.rb`: update dataset selections
10. `10_read_into_existing_array.rb`: read into an existing Numo array
11. `11_safe_type_conversion.rb`: control numeric conversions
12. `12_boolean_and_complex.rb`: store boolean and complex data
13. `13_chunked_storage.rb`: choose chunk layouts
14. `14_filters_and_integrity.rb`: use gzip, shuffle, and Fletcher32
15. `15_growing_datasets.rb`: resize and append data
16. `16_processing_in_blocks.rb`: process data within a byte budget
17. `17_processing_chunks.rb`: process chunk regions
18. `18_hierarchy_management.rb`: manage groups and datasets
19. `19_links.rb`: create and inspect links
20. `20_file_modes_and_errors.rb`: choose file modes and handle errors

If the HDF5 shared library cannot be found, set `HDF5_LIB_PATH` before running an example.
