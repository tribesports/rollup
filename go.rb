#!/usr/bin/env ruby

$:.unshift File.expand_path("../lib", __FILE__)

require 'rollup'

output = Rollup::Outputs::CSVRollupOutput.new
Rollup::Runner.new(output).run(ARGV[0])
