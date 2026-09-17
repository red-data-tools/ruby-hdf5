module HDF5
  class FileContext
    CLOSE_FUNCTIONS = {
      file: :H5Fclose,
      group: :H5Gclose,
      dataset: :H5Dclose
    }.freeze

    def initialize(file_id)
      @file_id = file_id
      @handles = { file_id => :file }
      @closed = false
    end

    def register(id, type)
      raise ClosedError, 'HDF5 file is closed' if closed?

      @handles[id] = type
      id
    end

    def close(id)
      synchronize do
        type = @handles[id]
        return if type.nil?

        status = HDF5::FFI.public_send(CLOSE_FUNCTIONS.fetch(type), id)
        raise HDF5::Error, "Failed to close HDF5 #{type}" if status < 0

        @handles.delete(id)
        @closed = true if type == :file
        nil
      end
    end

    def close_file
      synchronize do
        return if closed?

        children = @handles.keys.reject { |id| id == @file_id }
        children.reverse_each { |id| close(id) }
        close(@file_id)
      end
    end

    def ensure_open!(id = nil)
      raise ClosedError, 'HDF5 file is closed' if closed?
      raise ClosedError, 'HDF5 object is closed' if id && !@handles.key?(id)
    end

    def closed?
      @closed
    end

    def synchronize(&block)
      HDF5::FFI::CALL_LOCK.synchronize(&block)
    end

    def self.guard(*methods)
      Module.new do
        methods.each do |method|
          define_method(method) do |*args, **kwargs, &block|
            lock = @context || HDF5::FFI::CALL_LOCK
            lock.synchronize { super(*args, **kwargs, &block) }
          end
        end
      end
    end
  end
end
