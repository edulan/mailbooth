require 'json'
require 'digest'
require 'em-synchrony'
require 'em-synchrony/em-http'

module Mailbooth
  class API
    class << self
      def get(resource, options = {})
        request(:get, resource, options)
      end

      def post(resource, options = {})
        request(:post, resource, options)
      end

      def request(method, resource, options = {})
        default_headers = {
          'Accept' => 'application/json'
        }

        params = options.dup
        params[:head] ||= {}
        params[:head].merge!(default_headers)

        EM::HttpRequest.new("http://127.0.0.1:9292/api/#{resource}").send(
          method,
          params
        )
      end
    end
  end

  class Inbox
    attr_reader :id

    def initialize(attrs)
      @id = attrs['id']
    end

    def self.find_by(params)
      req = API.get('inboxes', query: params)
      res = req.response
      status = req.response_header.status

      return nil unless status == 200 && (attrs = JSON.load(res).first)

      self.new(attrs)
    end
  end

  class Message
    RCPT_SEPARATOR = ', '
    CRLF = "\r\n"

    attr_accessor :inbox
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
      return if inbox.nil?

      API.post(
        "inboxes/#{inbox.id}/messages",
        body: to_json,
        head: {
          'Content-Type' => 'application/json'
        }
      )
    end

    def to_json
      JSON.generate(
        sender: sender,
        recipients: recipients,
        data: data
      )
    end
  end

  class InboxAuthenticator
    include EM::Deferrable

    attr_reader :inbox

    def authenticate(credentials)
      EM.synchrony do
        auth = digest_credentials(credentials)

        if (inbox = Inbox.find_by(auth: auth))
          @inbox = inbox
          succeed
        else
          @inbox = nil
          fail
        end
      end
      self
    end

    private

    def digest_credentials(credentials)
      Digest::MD5.hexdigest(
        "#{credentials[:username]}:#{credentials[:password]}"
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

    def receive_plain_auth(user, pass)
      authenticator.authenticate(username: user, password: pass)
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
        current_message.inbox = @authenticator.inbox
        current_message.save
        reset!
      end
      # TODO: This should be moved to the synchrony block?
      true
    end

    def receive_data_chunk(data_chunk)
      current_message.add_data_chunk(data_chunk)
      true
    end

    def authenticator
      @authenticator ||= InboxAuthenticator.new
    end

    def current_message
      @current_message ||= Message.new
    end

    def reset!
      @authenticator = nil
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
