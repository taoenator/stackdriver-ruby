require 'json'

#
# See: http://feedback.stackdriver.com/knowledgebase/articles/181488-sending-custom-application-metrics-to-the-stackdri
#
module Stackdriver
  class Client
    module Custom

      ENDPOINT = 'v1/custom'.freeze

      @@data_points = []

      def custom(name, value, collected_at=Time.now.to_i, instance=nil)
        request(:post, ENDPOINT, gateway_message(make_data_point(name, value, collected_at, instance)))
      end

      def custom_multi()
        request(:post, ENDPOINT, gateway_message(@@data_points))
      end

      def add_data_point(name, value, collected_at=Time.now.to_i, instance=nil)
        @@data_points.push(make_data_point(name, value, collected_at, instance))
      end

      private

      #
      # Wraps the datapoint per doc.
      #
      def gateway_message(data)
        {
          data: data,
          timestamp: Time.now.to_i,
          proto_version: 1,
        }
      end

      def make_data_point(name, value, collected_at, instance)
        {
            name:         name,
            value:        value,
            collected_at: collected_at,
            instance:     instance,
        }
      end
    end
  end
end
