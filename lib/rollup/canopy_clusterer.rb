require 'java'

import org.apache.mahout.vectorizer.encoders.StaticWordValueEncoder
import org.apache.mahout.vectorizer.encoders.ConstantValueEncoder
import org.apache.mahout.common.distance.EuclideanDistanceMeasure
import org.apache.mahout.common.distance.CosineDistanceMeasure
import org.apache.mahout.clustering.canopy.Canopy
import org.apache.mahout.clustering.canopy.CanopyClusterer
import org.apache.mahout.math.DenseVector
import org.apache.mahout.math.RandomAccessSparseVector
import java.util.Map

module Rollup

  class CanopyClusterer
    DEFAULT_PARAMS = {
      :distance_measure => CosineDistanceMeasure.new,
      :t1 => 0.1,
      :t2 => 0.2,
      :features => 100000,
    }

    def initialize(analyzer, dictionary, params={}, &block)
      @params = DEFAULT_PARAMS.merge(params)
      @analyzer = analyzer
      @dictionary = dictionary
      @text_encoder = StaticWordValueEncoder.new("text")
      @algo = ::CanopyClusterer.new(@params[:distance_measure],
                                    @params[:t1],
                                    @params[:t2])
      @examples = []
      @vectors = {}
      @vector_maker = SentenceVectorMaker.new(@analyzer, @dictionary, @text_encoder)
      if block
        block.call(self)
      end
    end

    def add_example(example)
      @examples << example
      @analyzer.each_token_for(example[1]) do |token|
        @dictionary.add(token)
      end
    end

    def clusters
      @vectors = Hash[*@examples.map { |id, word| [id, vector_for(word)] }.flatten]
      @canopies = ::CanopyClusterer.create_canopies(@vectors.values,
                                                    @params[:distance_measure],
                                                    @params[:t1],
                                                    @params[:t2])
      @clusters = Hash.new { |h,k| h[k] = [] }
      @examples.each do |id, name, url|
        can = find_closest_canopy(@vectors[id], @canopies)
        if can && @algo.canopy_covers(can, vector_for(name))
          @clusters[can.get_identifier] << Product.new(name, url)
        else
          @clusters[id] << Product.new(name, url)
        end
      end
      @clusters
    end

    def find_closest_canopy(point, canopies)
      closest = nil
      min_dist = 100000
      canopies.each do |can|
        dist = point.minus(can.get_center).get_length_squared ** 0.5
        if dist < min_dist
          closest = can
          min_dist = dist
        end
      end
      closest
    end

    def canopies
      ::CanopyClusterer.get_centers(@canopies)
    end

    def dictionary
      @dictionary
    end

    def weight_for(word)
      @text_encoder.weight(word)
    end

    def average_distance(examples)
      examples.combination(2).inject(0.0) do |acc, (a, b)|
        acc + (vector_for(a).minus(vector_for(b)).get_length_squared) ** 0.5
      end / examples.length
    end

    private

    def vector_for(example)
      @vector_maker.vector_for(example, @params[:features])
    end
  end
end
