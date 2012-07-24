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
        puts @source.groups.map {|g| escape(g) }.join("\n")
      end

      private
      def escape(tuple)
        tuple.map {|v| "\"#{v}\""}.join(",")
      end
    end
  end
end
