require 'rubygems'
require 'java'
Dir[File.expand_path("../../vendor/*.jar", __FILE__)].each do |jar|
  require jar
end
require 'csv'
require 'htmlentities'
require 'rollup/canopy_clusterer'
require 'rollup/text_analyzer'
require 'rollup/weighted_dictionary'

import org.apache.lucene.analysis.standard.StandardFilter
import org.apache.lucene.analysis.standard.StandardAnalyzer
import org.apache.lucene.analysis.LowerCaseFilter
import org.apache.lucene.analysis.StopFilter
import org.apache.lucene.analysis.PorterStemFilter
import org.apache.lucene.util.Version


module Rollup

  extend self

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

  def run(data_file)
    data = CSV.read(data_file).shuffle

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

    clusterer = Rollup::CanopyClusterer.new(analyzer, WeightedDictionary.new) do |clusterer|
      data.each do |example|
        clusterer.add_example(example)
      end

      clusters = clusterer.clusters

      clusters.each do |k, v|
        if v.length > 1
          puts "#{k}: (#{clusterer.average_distance(v)})"
          v.each { |name| puts "  #{name}" }
        end
      end

      puts "#{data.length} entries clustered into #{clusters.length} product clusters"
    end
  end
end
