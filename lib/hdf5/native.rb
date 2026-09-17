# frozen_string_literal: true

module HDF5
  # Internal helpers for native return values and resource cleanup.
  module Native
    module_function

    def check(value, message)
      raise NativeError, message if value.negative?

      value
    end

    def datatype_class(type_id)
      value = HDF5::FFI.H5Tget_class(type_id)
      raise NativeError, 'Failed to get datatype class' if value == :H5T_NO_CLASS

      value
    end

    def extent_type(space_id)
      value = HDF5::FFI.H5Sget_simple_extent_type(space_id)
      raise NativeError, 'Failed to get dataspace type' if value == :H5S_NO_CLASS

      value
    end

    # Attempt every close, while preserving an exception already in flight.
    def close(*handles)
      active_error = $ERROR_INFO
      close_error = nil
      handles.each do |function, id|
        next unless id && id >= 0

        begin
          check(HDF5::FFI.public_send(function, id), "Failed to close HDF5 resource (#{function})")
        rescue StandardError => error
          close_error ||= error
        end
      end
      raise close_error if close_error && active_error.nil?
    end

    def close_object(object)
      active_error = $ERROR_INFO
      object&.close
    rescue StandardError
      raise if active_error.nil?
    end
  end
end
