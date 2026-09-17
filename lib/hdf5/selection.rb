module HDF5
  class Selection
    attr_reader :start, :stride, :count, :result_shape

    def self.normalize(selection, shape)
      return new(Array.new(shape.length, true), shape) if selection.nil?

      selectors = selection.is_a?(Array) ? selection.dup : [selection]
      raise IndexError, 'Too many indices for dataset' if selectors.length > shape.length

      selectors.concat(Array.new(shape.length - selectors.length, true))
      new(selectors, shape)
    end

    def initialize(selectors, shape)
      @start = []
      @stride = []
      @count = []
      @result_shape = []
      @result_axes = []

      selectors.zip(shape).each_with_index do |(selector, dimension), axis|
        @result_axes << axis unless selector.is_a?(Integer)
        normalize_axis(selector, dimension)
      end
    end

    def scalar?
      result_shape.empty?
    end

    def size
      count.inject(1, :*)
    end

    def block(ranges)
      result = dup
      starts = start.dup
      counts = count.dup
      @result_axes.zip(ranges).each do |axis, range|
        starts[axis] += range.begin * stride[axis]
        counts[axis] = range.end - range.begin
      end
      result.instance_variable_set(:@start, starts)
      result.instance_variable_set(:@count, counts)
      result.instance_variable_set(:@result_shape, ranges.map { |range| range.end - range.begin })
      result
    end

    private

    def normalize_axis(selector, dimension)
      case selector
      when true
        @start << 0
        @stride << 1
        @count << dimension
        @result_shape << dimension
      when Integer
        index = selector.negative? ? dimension + selector : selector
        unless index.between?(0, dimension - 1)
          raise IndexError, "Index #{selector} is outside dimension of size #{dimension}"
        end

        @start << index
        @stride << 1
        @count << 1
      when Range
        first, last = normalize_range(selector, dimension)
        @start << first
        @stride << 1
        @count << last - first
        @result_shape << last - first
      when HDF5::Slice
        unless selector.step.is_a?(Integer) && selector.step.positive?
          raise IndexError, 'Slice step must be a positive integer'
        end
        raise IndexError, 'Slice range must be a Range' unless selector.range.is_a?(Range)

        first, last = normalize_range(selector.range, dimension)
        count = (last - first).fdiv(selector.step).ceil
        @start << first
        @stride << selector.step
        @count << count
        @result_shape << count
      else
        raise IndexError, "Unsupported index: #{selector.inspect}"
      end
    end

    def normalize_range(range, dimension)
      unless [range.begin, range.end].all? { |value| value.nil? || value.is_a?(Integer) }
        raise IndexError, 'Range endpoints must be integers'
      end

      first = range.begin.nil? ? 0 : range.begin
      last = range.end.nil? ? dimension : range.end
      first += dimension if first.negative?
      last += dimension if last.negative?
      last += 1 unless range.exclude_end? || range.end.nil?

      first = [[first, 0].max, dimension].min
      last = [[last, 0].max, dimension].min
      [first, [last, first].max]
    end
  end
end
