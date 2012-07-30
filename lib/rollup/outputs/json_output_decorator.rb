module Rollup
  module Outputs
    class JSONOutputDecorator
      def initialize(source)
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
        @source.groups.to_json
      end
    end
  end
end
