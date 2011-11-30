#!/usr/bin/env ruby

$:.unshift File.expand_path("../lib", __FILE__)

require 'rollup'

Rollup.run(ARGV[0])
