require 'spec_helper'

require 'net/smtp'
require 'net/http'
require 'mail'

SMTP_HOST = '127.0.0.1'
SMTP_PORT = '1025'
SMTP_BIN_PATH = File.expand_path('../../bin/smtpserver', __FILE__)
API_HOST = '127.0.0.1'
API_PORT = 9292
API_CONFIG_PATH = File.expand_path('../../config.ru', __FILE__)
API_BASE_PATH = '/api'

Mail.defaults do
  delivery_method :smtp,
                  address: SMTP_HOST,
                  port: SMTP_PORT,
                  authentication: 'plain',
                  user_name: 'foo',
                  password: '123'
end

RSpec.describe 'Mailbooth' do
  context 'sending an email' do
    before(:context) do
      spawn_servers
    end

    after(:context) do
      kill_servers
    end

    class MessageNotFound < StandardError; end
    class AwaitingMessage < StandardError; end

    def spawn_servers
      @smtp_pid = spawn(
        { 'SMTP_HOST' => SMTP_HOST, 'SMTP_PORT' => SMTP_PORT },
        "bundle exec ruby #{SMTP_BIN_PATH}",
        out: '/dev/null'
      )
      @api_pid = spawn(
        "bundle exec rackup #{API_CONFIG_PATH} --quiet",
        out: '/dev/null'
      )

      # Wait for servers to be ready
      begin
        TCPSocket.new(SMTP_HOST, SMTP_PORT).close
        TCPSocket.new(API_HOST, API_PORT).close
      rescue Errno::ECONNREFUSED
        sleep 0.3
        retry
      end
    end

    def kill_servers
      Process.kill('TERM', @smtp_pid)
      Process.kill('TERM', @api_pid)
      Process.wait
    end

    def compose_mail(name, options = {})
      mail = Mail.new(read_example(name))
      # TODO: Apply options
      mail
    end

    def wait_for_mail(mail)
      uri = URI::HTTP.build(
        host: API_HOST,
        port: API_PORT,
        path: "#{API_BASE_PATH}/inboxes/1/messages")

      http = Net::HTTP.new(uri.host, uri.port)
      request = Net::HTTP::Get.new(uri.request_uri)

      total_tries = 3
      tries_count = 0
      begin
        response = http.request(request)
        fail(MessageNotFound) if response.is_a?(Net::HTTPNotFound)

        yield({ status: :error, result: nil }) unless response.is_a?(Net::HTTPSuccess)

        result = JSON.parse(response.body)

        fail(AwaitingMessage) if result.empty?
        yield({ status: :success, result: result })
      rescue MessageNotFound, AwaitingMessage
        tries_count += 1

        if total_tries > tries_count
          sleep(tries_count**3 * 0.1)
          retry
        else
          yield({ status: :timeout, result: nil })
        end
      end
    end

    def read_example(name)
      File.read(File.expand_path("../../examples/#{name}", __FILE__))
    end

    let(:mail_example) { compose_mail('quoted_printable_htmlmail') }

    it 'stores the email' do
      mail_example.deliver

      wait_for_mail(mail_example) do |response|
        expect(response[:status]).to eq(:success)
        expect(response[:result].length).to eq(1)
      end
    end
  end
end
