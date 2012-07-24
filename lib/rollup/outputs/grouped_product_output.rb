module Rollup
  module Outputs
    class GroupedProductOutput
      def initialize
        @groups = []
        @next_identifier = 0
        @category_identifiers = Hash.new do |h, k|
          @next_identifier += 1
          h[k] = @next_identifier
        end
      end

      def start(count)
        #noop - don't care
      end

      def cluster(cluster_info)
        cluster_info.values.
          map {|v| [cluster_info.id, v.name, v.url] }.
          each do |val| 
            @groups << [@category_identifiers[val[0]], val].flatten
          end
      end

      def finish
        #noop - don't care
      end

      def groups
        @groups
      end
    end
  end
end
