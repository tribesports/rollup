class ConsoleRollupOutput
  def initialize
    @cluster_count = 0
  end

  def data(count)
    @count = count
  end

  def cluster(cluster_info)
    @cluster_count += 1
    puts "#{cluster_info.id}: (#{cluster_info.average_distance})"
    cluster_info.values.each { |val| puts " #{val}" }
  end

  def finish
    puts "#{@count} entries clustered into #{@cluster_count} clusters"
  end
end
