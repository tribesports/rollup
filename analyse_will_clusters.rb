#!/usr/bin/env ruby

$:.unshift File.expand_path("../lib", __FILE__)

require 'rollup'

debug = (ARGV[2] == "debug")

analyzer = Rollup::TextAnalyzer.new(Version::LUCENE_36) do |a|
  h = HTMLEntities.new
  a.pre_processor do |text|
    h.decode(text).gsub(Rollup::Runner::STOP_WORDS_REGEX, "")
  end
  a.filter StandardFilter
  a.filter LowerCaseFilter
  a.filter(StopFilter) {|token_stream| [a.version, token_stream, StandardAnalyzer::STOP_WORDS_SET] }
  #      a.filter PorterStemFilter
end
dictionary = Rollup::WeightedDictionary.new
text_encoder = StaticWordValueEncoder.new("text")

sentence_vector_maker = Rollup::SentenceVectorMaker.new(analyzer, dictionary, text_encoder)
examples = CSV.read(ARGV[0]).map {|v| v[2] } #get them in groups
examples.each {|e| sentence_vector_maker.add_example(e) }
group_collector = Rollup::Outputs::GroupedProductOutput.new
Rollup::Inputs::CSVGroupImport.new(group_collector).run(ARGV[0])
groups_with_more_than_one = group_collector.groups.group_by(&:first).select {|cat, products| products.size > 1 }
interesting_groups = groups_with_more_than_one.reject {|cat, products| products.all? {|p| p[2] == products.first[2] }}
averages = group_collector.groups.group_by(&:first).map do |cat, products|
  examples = products.map {|p| p[2] }
  sentence_vector_maker.average_distance(examples)
end
puts "Will's samples, average distance:"
puts averages.inject(:+) / averages.size

actual_group_collector = Rollup::Outputs::GroupedProductOutput.new
Rollup::Runner.new(actual_group_collector).run(ARGV[1])
actual_groups_with_more_than_one = actual_group_collector.groups.group_by(&:first).select {|cat, products| products.size > 1 }
actual_interesting_groups = actual_groups_with_more_than_one.reject {|cat, products| products.all? {|p| p[2] == products.first[2] }}
actual_averages = actual_group_collector.groups.group_by(&:first).map do |cat, products|
  examples = products.map {|p| p[2] }
  sentence_vector_maker.average_distance(examples)
end

puts "Actual output, average distance:"
puts actual_averages.inject(:+) / actual_averages.size

if debug
  puts "Interesting groups in will clusters:"
  puts interesting_groups.map {|cat, products| products.map {|p| p[2]}.join(", ") + " (#{products.size})"}.join("\n\n")

  puts "Interesting groups in actual clusters:"
  puts actual_interesting_groups.map {|cat, products| products.map {|p| p[2]}.join(", ") + " (#{products.size})"}.join("\n\n")
end
