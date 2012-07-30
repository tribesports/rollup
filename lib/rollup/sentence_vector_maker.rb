require 'java'
import org.apache.mahout.math.RandomAccessSparseVector

module Rollup
  class SentenceVectorMaker
    def initialize(analyzer, dictionary, text_encoder)
      @analyzer = analyzer
      @dictionary = dictionary
      @text_encoder = text_encoder
      @examples = []
    end

    def add_example(example)
      @examples << example
      @analyzer.each_token_for(example) do |token|
        @dictionary.add(token)
      end
    end

    def vector_for(example, features)
      vector = RandomAccessSparseVector.new(features)
      @analyzer.each_token_for(example) do |token|
        @text_encoder.add_to_vector(token, @dictionary.weight(token), vector)
      end
      vector.normalize
    end

    def average_distance(examples)
      examples.combination(2).inject(0.0) do |acc, (a, b)|
        acc + (vector_for(a, 100000).minus(vector_for(b, 100000)).get_length_squared) ** 0.5
      end / examples.length
    end
  end
end
