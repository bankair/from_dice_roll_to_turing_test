# frozen_string_literal: true

# Character wrapper class
class Trigram
  class << self
    def last(buffer) = buffer.last(3)

    def extract(element) = element.last

    def iterate_over(chars)
      raise 'Missing block' unless block_given?

      n_minus2 = chars[0]
      n_minus1 = chars[1]
      chars[2..].each do |char|
        yield [n_minus2, n_minus1, char]
        n_minus2 = n_minus1
        n_minus1 = char
      end
    end
  end
end
