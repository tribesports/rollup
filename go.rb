#!/usr/bin/env ruby

$:.unshift File.expand_path("../lib", __FILE__)

require 'rollup'

Rollup::Runner.new(ConsoleRollupOutput.new).run(ARGV[0])
