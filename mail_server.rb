require 'ostruct'
require 'eventmachine'
require './models/inbox'
require './models/mail'
require './models/mail_data'
require './models/mail_address'

module Mailbooth
  class MailServer < EM::P::SmtpServer
    def get_server_domain
      'smtp.mailbooth.local'
    end

    def get_server_greeting
      'Greetings from Mailbooth'
    end

    def receive_sender(sender)
      current_mail.sender = Models::MailAddress.new(sender).to_s
      true
    end

    def receive_recipient(recipient)
      current_mail.recipient = Models::MailAddress.new(recipient).to_s
      true
    end

    def receive_message
      current_mail.received_at = Time.now
      current_inbox.add_mail(current_mail)
      reset_mail!
      true
    end

    def receive_data_chunk(data)
      mail_data = Models::MailData.new(data)

      current_mail.subject = mail_data.subject
      current_mail.source = mail_data.source
      true
    end

    def current_mail
      @current_mail ||= Models::Mail.new
    end

    def reset_mail!
      @current_mail = nil
    end

    def current_inbox
      Models::Inbox.find(name: current_mail.sender).first ||
        Models::Inbox.create(name: current_mail.sender)
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
