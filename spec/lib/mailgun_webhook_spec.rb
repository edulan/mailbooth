require 'spec_helper'

require 'hashie'
require './lib/mailgun_webhook'

RSpec.describe Mailbooth::MailgunWebhook do
  describe '#verify' do
    let(:api_key) { 'key-00000000000000000000000000000000' }
    let(:params) do
      params = Hashie::Mash.new
      params.token = '00000000000000000000000000000000000000000000000000'
      params.timestamp = '0000000000'
      params.signature = 'ee8d99784974eafc7f53395d3746c76bcf7bbd510462025e1001fb7d612b377f'
      params
    end

    subject { Mailbooth::MailgunWebhook.new(api_key).verify(params) }

    it { is_expected.to be(true) }
  end
end
