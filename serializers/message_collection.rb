require './serializers/base'
require './serializers/message'

module Mailbooth
  module Serializers
    class MessageCollection < Base
      def serialize
        object.map do |model|
          Message.new(model).to_json
        end
      end
    end
  end
end
