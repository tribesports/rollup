#!/usr/bin/env ruby

$:.unshift File.expand_path("../../lib", __FILE__)

require 'rollup'

output = Rollup::Outputs::JSONOutputDecorator.new(Rollup::Outputs::GroupedProductOutput.new)
Rollup::Runner.new(output).run(ARGF.read)
puts output.result
