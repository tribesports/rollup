#!/usr/bin/env ruby

$:.unshift File.expand_path("../../lib", __FILE__)

require 'rollup'

output = Rollup::Outputs::JSONOutputDecorator.new(Rollup::Outputs::GroupedProductOutput.new)
word_weight_boosts = {}
ARGV.each do |arg|
  word, weight_boost = arg.split("=")
  word_weight_boosts[word] = weight_boost.to_f
end
Rollup::Runner.new(output, word_weight_boosts).run(STDIN.read)
puts output.result
