#!/usr/bin/env ruby

$:.unshift File.expand_path("../lib", __FILE__)

require 'rollup'

output = Rollup::Outputs::CSVOutputDecorator.new(Rollup::Outputs::GroupedProductOutput.new)
Rollup::Runner.new(output).run(ARGV[0])
puts output.result
