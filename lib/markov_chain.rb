# frozen_string_literal: true

require 'yaml'

# Markov chain wrapper class
class Markov
  class Chain
    attr_reader :hits

    def initialize(hash: Hash.new { |h, k| h[k] = Hash.new(0) })
      @hits = hash
    end

    def hit_maps
      @hit_maps ||= {}
    end

    def hit_map(element)
      hit_maps.fetch(element) do
        hit_maps[element] =
          hits[element]
          .flat_map { |value, count| [value] * count }
      end
    end

    def sample(previous)
      hit_map(previous).sample
    end

    def run(size, split_strategy)
      result = Array(hits.flat_map { |k, v| [k] * v.values.sum }.sample)
      loop do
        result << sample(split_strategy.last(result))
        return result if result.size >= size
      end
    end

    def self.extract(buffer, split_strategy)
      previous = nil
      markov_chain = new
      chars =
        I18n
        .transliterate(buffer)
        .upcase
        .gsub(/[ \r\n]+/, ' ')
        .chars
      split_strategy.iterate_over(chars) do |element|
        unless previous
          previous = element
          next
        end

        markov_chain.hits[previous][split_strategy.extract(element)] += 1
        previous = element
      end
      markov_chain
    end

    def to_yaml
      hits.to_yaml
    end

    def self.load(buffer)
      new(YAML.load(buffer))
    end
  end
end
