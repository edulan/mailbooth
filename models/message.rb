require 'ohm'
require 'ohm/contrib'
require 'mail'

module Mailbooth
  module Models
    class Message < Ohm::Model
      include Ohm::Callbacks

      DEFAULT_MIME_TYPE = 'text/plain'

      attribute :sender
      attribute :recipients
      attribute :data
      # Fields parsed from `data` attribute
      attribute :from
      attribute :to
      attribute :subject
      attribute :body
      attribute :type
      attribute :received_at

      index :from
      index :to

      private

      def before_save
        mail = Mail.new(data)

        self.from = mail.from.join(',')
        self.to = mail.to.join(',')
        self.subject = mail.subject
        self.body = mail.body.to_s
        self.type = mail.mime_type || DEFAULT_MIME_TYPE
        self.received_at = Time.now
      end
    end
  end
end
