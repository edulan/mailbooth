require './serializers/base'

module Mailbooth
  module Serializers
    class Inbox < Base
      def serialize
        attrs = {
          name: object.name
        }

        object.to_hash.merge(attrs)
      end
    end
  end
end
