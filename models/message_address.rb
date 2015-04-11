module Mailbooth
  module Models
    class MessageAddress
      def initialize(data)
        @data = data
      end

      def to_s
        normalized_data
      end

      private

      private

      attr_reader :data

      def normalized_data
        data.gsub(/<(.*)>/, '\1')
      end
    end
  end
end
