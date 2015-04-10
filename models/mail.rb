require 'ohm'

module Mailbooth
  module Models
    class Mail < Ohm::Model
      attribute :sender
      attribute :recipient
      attribute :subject
      attribute :source
      attribute :size
      attribute :type
      attribute :received_at

      def to_hash
        attrs = super
        attrs.merge(
          sender: sender,
          recipient: recipient,
          subject: subject,
          received_at: received_at
        )
      end
    end
  end
end
