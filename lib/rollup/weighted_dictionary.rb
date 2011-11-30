module Rollup
  class WeightedDictionary
    def initialize
      @words = []
      @counts = Hash.new(0)
    end

    def add(word)
      @words << word
      @counts[word] += 1
    end

    def count(word)
      @counts[word]
    end

    def weight(word)
      if @counts[word]
        weight_for(word)
      else
        raise ArgumentError, "Word #{word} not found in dictionary"
      end
    end

    def weight_map
      Hash[*@counts.keys.map{|w| [w, weight_for(w)]}.flatten]
    end

    def to_s
      @counts.map do |k, v|
        "[#{v}] #{k}"
      end.join("\n")
    end

    private

    # Cribbed from Mahout's AdaptiveWordValueEncoder
    def weight_for(word)
      if word =~ /adult|junior/i
        6.0
      else
        -Math.log( (@counts[word] + 0.5) / (@words.length + (@counts.keys.length / 2) + 0.5) )
      end
    end

  end
end
