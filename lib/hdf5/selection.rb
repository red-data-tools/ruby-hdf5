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

      selectors.zip(shape).each do |selector, dimension|
        normalize_axis(selector, dimension)
      end
    end

    def scalar?
      result_shape.empty?
    end

    def size
      count.inject(1, :*)
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
        raise IndexError, "Index #{selector} is outside dimension of size #{dimension}" unless index.between?(0, dimension - 1)

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