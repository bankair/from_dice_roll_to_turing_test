# frozen_string_literal: true

# Character wrapper class
class Char
  class << self
    def last(buffer)
      buffer.last
    end

    def iterate_over(chars, &block)
      raise 'Missing block' unless block_given?

      chars.each(&block)
    end
  end
end
