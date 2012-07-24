module Rollup
  module Inputs
    module CSVGroupImport
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
        @groups.each do |g, v|
          @output.cluster(Cluster.new(g, 0.0, Product.new(v[2], v[3]))) 
        end
        @output.finish
      end
    end
  end
end
