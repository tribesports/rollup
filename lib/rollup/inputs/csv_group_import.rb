module Rollup
  module Inputs
    class CSVGroupImport
      def initialize(output)
        @output = output
        @groups = Hash.new do |h, k|
          h[k] = []
        end
      end

      def run(data_file)
        data = CSV.read(data_file)
        @output.start(data.length)
        data.each do |row|
          @groups[row[1]] << row
        end
        @groups.each do |group, values|
          products = values.compact.map {|v| Product.new(v[2], v[3]) }
          @output.cluster(Cluster.new(group, 0.0, products)) 
        end
        @output.finish
      end
    end
  end
end
