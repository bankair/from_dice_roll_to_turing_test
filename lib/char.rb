# frozen_string_literal: true

# Character wrapper class
class Char
  class << self
    def last(buffer) = buffer.last

    def extract(element) = element

    def iterate_over(chars, &block)
      raise 'Missing block' unless block_given?

      chars.each(&block)
    end
  end
end
