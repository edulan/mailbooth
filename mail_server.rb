require 'ostruct'
require 'eventmachine'
require './models/inbox'
require './models/message'
require './models/message_data'
require './models/message_address'

module Mailbooth
  class MailServer < EM::P::SmtpServer
    def get_server_domain
      'smtp.mailbooth.local'
    end

    def get_server_greeting
      'Greetings from Mailbooth'
    end

    def receive_sender(sender)
      current_message.sender = Models::MessageAddress.new(sender).to_s
      true
    end

    def receive_recipient(recipient)
      current_message.recipient = Models::MessageAddress.new(recipient).to_s
      true
    end

    def receive_message
      current_message.received_at = Time.now
      current_inbox.add_message(current_message)
      reset_message!
      true
    end

    def receive_data_chunk(data)
      message_data = Models::MessageData.new(data)

      current_message.subject = message_data.subject
      current_message.source = message_data.source
      true
    end

    def current_message
      @current_message ||= Models::Message.new
    end

    def reset_message!
      @current_message = nil
    end

    def current_inbox
      Models::Inbox.find(name: current_message.sender).first ||
        Models::Inbox.create(name: current_message.sender)
    end

    class << self
      def start(host = 'localhost', port = 1025)
        @redis = Ohm.redis = Redic.new('redis://127.0.0.1:6379')
        @server = EM.start_server(host, port, self)
      end

      def stop
        return unless running?

        EM.stop_server(@server)
        @server = nil
      end

      def running?
        !@server.nil?
      end
    end
  end
end
