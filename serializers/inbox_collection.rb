require './serializers/base'
require './serializers/inbox'

module Mailbooth
  module Serializers
    class InboxCollection < Base
      def serialize
        object.map do |model|
          Inbox.new(model).to_json
        end
      end
    end
  end
end