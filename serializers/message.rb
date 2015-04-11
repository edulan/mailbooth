require './serializers/base'

module Mailbooth
  module Serializers
    class Message < Base
      def serialize
        attrs = {
          sender: sender,
          recipient: recipient,
          subject: subject,
          received_at: received_at
        }

        object.to_hash.merge(attrs)
      end
    end
  end
end
