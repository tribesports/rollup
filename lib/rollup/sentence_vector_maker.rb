require 'java'
import org.apache.mahout.math.RandomAccessSparseVector

class SentenceVectorMaker
  def initialize(analyzer, dictionary, text_encoder)
    @analyzer = analyzer
    @dictionary = dictionary
    @text_encoder = text_encoder
  end

  def vector_for(example, features)
    vector = RandomAccessSparseVector.new(features)
    @analyzer.each_token_for(example) do |token|
      @text_encoder.add_to_vector(token, @dictionary.weight(token), vector)
    end
    return vector.normalize
  end
end
