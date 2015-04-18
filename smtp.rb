require 'json'
require 'em-synchrony'
require 'em-synchrony/em-http'

module Mailbooth
  class IncomingMessage
    RCPT_SEPARATOR = ', '
    CRLF = "\r\n"

    attr_accessor :sender, :recipients, :data

    def add_recipient(recipient)
      self.recipients ||= ''
      self.recipients << RCPT_SEPARATOR unless recipients.empty?
      self.recipients << recipient.to_s
    end

    def add_data_chunk(data_chunk)
      self.data ||= ''
      self.data << data_chunk.join(CRLF) << CRLF
    end

    def save
      EM::HttpRequest.new('http://127.0.0.1:9292/api/inboxes/1/messages').post(
        body: to_json,
        head: {
          'Accept' => 'application/json',
          'Content-Type' => 'application/json'
        }
      )
    end

    private

    def to_json
      JSON.generate(
        sender: sender,
        recipients: recipients,
        data: data
      )
    end
  end

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
      EM.synchrony do
        current_message.save
        reset_message!
      end
      true
    end

    def receive_data_chunk(data_chunk)
      current_message.add_data_chunk(data_chunk)
      true
    end

    def current_message
      @current_message ||= IncomingMessage.new
    end

    def reset_message!
      @current_message = nil
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
