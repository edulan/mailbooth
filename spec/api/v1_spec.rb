require 'spec_helper'

require 'rack/test'
require './app/api/v1'

RSpec.describe Mailbooth::API::V1 do
  include Rack::Test::Methods

  def app
    Mailbooth::API::V1
  end

  describe 'GET /messages' do
    let(:messages) do
      (1..3).map do |i|
        instance_double(
          'Mailbooth::Models::Message',
          id: "#{i}",
          to: 'blah@blah.com',
          from: 'me@sj26.com',
          subject: 'Test mail',
          body: 'Test mail.',
          text_body: 'Test mail.',
          html_body: '<h1>Test mail.</h1>',
          received_at: Time.now,
          type: 'text/plain'
        )
      end
    end

    context 'searching by inbox' do
      let(:params) { { to: 'foo@bar.com' } }

      before do
        allow(Mailbooth::Models::Message).to receive(:find).with(params).and_return(messages)
        get '/messages', params
      end

      context 'response status' do
        subject { last_response.status }

        it { is_expected.to be(200) }
      end

      context 'response length' do
        subject { JSON.parse(last_response.body).length }

        it { is_expected.to eq(messages.length) }
      end

      context 'response body' do
        let(:first_message) { messages.first }

        subject { JSON.parse(last_response.body).first }

        it { expect(subject['id']).to eq(first_message.id) }
        it { expect(subject['to']).to eq(first_message.to) }
        it { expect(subject['subject']).to eq(first_message.subject) }
      end
    end
  end
end
