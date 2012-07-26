require 'rubygems'
require 'java'
Dir[File.expand_path("../../vendor/*.jar", __FILE__)].each do |jar|
  require jar
end
require 'csv'
require 'htmlentities'
require 'rollup/sentence_vector_maker'
require 'rollup/canopy_clusterer'
require 'rollup/text_analyzer'
require 'rollup/weighted_dictionary'
require 'rollup/cluster'
require 'rollup/product'
require 'rollup/outputs'
require 'rollup/inputs/csv_group_import'

import org.apache.lucene.analysis.standard.StandardFilter
import org.apache.lucene.analysis.standard.StandardAnalyzer
import org.apache.lucene.analysis.LowerCaseFilter
import org.apache.lucene.analysis.StopFilter
import org.apache.lucene.analysis.PorterStemFilter
import org.apache.lucene.util.Version


module Rollup
  class Runner
    def initialize(output)
      @output = output
    end

    STOP_WORDS = %w{
      cricket
      bat
      adult
      football
      gray
      nicolls
      shimano
      hubs?
    }

    STOP_WORDS_REGEX = Regexp.new(STOP_WORDS.map{|w| "\\b#{w}\\b"}.join("|"), true)

    def run(data_file, params={})
      data = CSV.read(data_file).shuffle
      @output.start(data.length)

      analyzer = TextAnalyzer.new(Version::LUCENE_36) do |a|
        h = HTMLEntities.new
        a.pre_processor do |text|
          h.decode(text).gsub(STOP_WORDS_REGEX, "")
        end
        a.filter StandardFilter
        a.filter LowerCaseFilter
        a.filter(StopFilter) {|token_stream| [a.version, token_stream, StandardAnalyzer::STOP_WORDS_SET] }
  #      a.filter PorterStemFilter
      end

      clusterer = Rollup::CanopyClusterer.new(analyzer, WeightedDictionary.new, params) do |clusterer|
        data.each do |example|
          clusterer.add_example(example)
        end

        clusters = clusterer.clusters

        clusters.each do |k, v|
          cluster = Cluster.new(k, clusterer.average_distance(v), v)
          @output.cluster(cluster)
        end

        @output.finish
      end
    end
  end
end
