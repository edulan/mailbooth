require 'eventmachine'

require './config/redis'
require './models'

module Mailbooth
  class Smtp < EM::P::SmtpServer
    def get_server_domain
      'smtp.mailbooth.local'
    end

    def get_server_greeting
      'Greetings from Mailbooth'
    end

    def receive_sender(sender)
      current_message.sender = sender
      true
    end

    def receive_recipient(recipient)
      current_message.add_recipient(recipient)
      true
    end

    def receive_message
      EM.defer do
        current_inbox.add_message(current_message)
        reset_message!
      end
      true
    end

    def receive_data_chunk(data_chunk)
      current_message.add_data_chunk(data_chunk)
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
