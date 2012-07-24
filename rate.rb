#!/usr/bin/env ruby

$:.unshift File.expand_path("../lib", __FILE__)

require 'rollup'

class GroupDiff
  def initialize(best, actual)
    @best_count = best.keys.size
    @actual_count = actual.keys.size
  end

  def to_s
    "Best: #{@best_count}\n
     Actual: #{@actual_count}\n
     Diff: #{@best_count - @actual_count}"
  end
end

best_groups_collector = Rollup::Outputs::GroupedProductOutput.new
Rollup::Inputs::CSVGroupImport.new(best_groups_collector).run(ARGV[0])
best_groups = best_groups_collector.groups

actual_groups_collector = Rollup::Outputs::GroupedProductOutput.new
Rollup::Runner.new(actual_groups_collector).run(ARGV[1])
actual_groups = actual_groups_collector.groups

diff = GroupDiff.new(best_groups, actual_groups)
puts diff
