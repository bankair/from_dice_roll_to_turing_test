# frozen_string_literal: true

require 'yaml'
require_relative './char'

# Markov chain wrapper class
class Markov
  class Node
  end

  class Chain
    attr_reader :hits

    def initialize(hash = Hash.new { |h, k| h[k] = Hash.new(0) })
      @hits = hash
    end

    def [](index)
      hits[index]
    end

    def hit_maps
      @hit_maps ||= {}
    end

    def hit_map(index)
      hit_maps.fetch(index) do
        hit_maps[index] =
          hits[index]
          .flat_map { |value, count| [value] * count }
      end
    end

    def sample(previous_index)
      hit_map(previous_index).sample
    end

    def run(size, split_strategy)
      result = [hits.keys.sample]
      loop do
        current = sample(split_strategy.last(result))
        result << current
        break if result.size >= size
      end
      result
    end

    def to_yaml
      hits.to_yaml
    end

    def self.load(buffer)
      new(YAML.load(buffer))
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
      split_strategy.iterate_over(chars) do |char|
        unless previous
          previous = char
          next
        end

        markov_chain[previous][char] += 1
        previous = char
      end
      markov_chain
    end
  end
end
