require 'ohm'
require 'ohm/contrib'
require 'mail'

module Mailbooth
  module Models
    class Message < Ohm::Model
      include Ohm::Callbacks

      RCPT_SEPARATOR = ', '
      CRLF = "\r\n"

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

      def add_recipient(recipient)
        self.recipients ||= ''
        self.recipients << RCPT_SEPARATOR unless recipients.empty?
        self.recipients << recipient.to_s
      end

      def add_data_chunk(data_chunk)
        self.data ||= ''
        self.data << data_chunk.join(CRLF) << CRLF
      end

      private

      def before_save
        mail = Mail.new(data)

        self.from = mail.from.join(',')
        self.to = mail.to.join(',')
        self.subject = mail.subject
        self.body = mail.body.to_s
        self.type = mail.mime_type
        self.received_at = mail.date.to_time
      end
    end
  end
end
