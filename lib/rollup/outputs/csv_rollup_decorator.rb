module Rollup
  module Outputs
    class CSVOutputDecorator
      def initialize(source)
        @csv_rows = []
        @source = source
      end

      def start(count)
        @source.start(count)
      end

      def cluster(cluster_info)
        @source.cluster(cluster_info)
      end

      def finish
        @source.finish
      end
      
      def result
        @source.groups.map {|g| CSV.generate_line(g) }.join("\n")
      end
    end
  end
end
