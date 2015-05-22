require 'openssl'

module Mailbooth
  class MailgunWebhook
    def initialize(api_key)
      @api_key = api_key
    end

    def verify(params)
      token, timestamp, signature = extract_tokens(params)

      hash = OpenSSL::HMAC.hexdigest(
        OpenSSL::Digest::SHA256.new,
        api_key,
        "#{timestamp}#{token}"
      )

      signature == hash
    end

    private

    attr_reader :token, :timestamp, :signature

    def extract_tokens(params)
      %w(token timestamp signature).map { |method| params.send(method) }
    end

    def api_key
      ensure_api_key! and @api_key
    end

    def ensure_api_key!
      fail 'Mailgun API key not provided' if @api_key.nil?
      true
    end
  end
end