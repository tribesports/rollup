module Rollup
  module Outputs
    class CSVRollupOutput
      def initialize
        @csv_rows = []
      end

      def start(count)
        #noop - don't care
      end

      def cluster(cluster_info)
        cluster_info.values.map {|v| [cluster_info.id, v.name, v.url] }.
          each {|tuple| @csv_rows << escape(tuple)}
      end

      def finish
        puts @csv_rows.join("\n")
      end

      private
      def escape(tuple)
        tuple.map {|v| "\"#{v}\""}.join(",")
      end
    end
  end
end
