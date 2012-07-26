#!/usr/bin/env ruby

$:.unshift File.expand_path("../lib", __FILE__)

require 'rollup'

class MeanDistanceAnalyser
  attr_reader :average_distances
  def initialize
    @average_distances = []
  end

  def start(stuff)
  end

  def cluster(cluster_info)
    @average_distances << cluster_info.average_distance
  end

  def finish
  end
end

analyser = MeanDistanceAnalyser.new
Rollup::Runner.new(analyser).run(ARGV[0], false)
puts analyser.average_distances.inspect
