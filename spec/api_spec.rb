require 'spec_helper'

require 'rack/test'
require './api'

RSpec.describe Mailbooth::API do
  include Rack::Test::Methods

  def app
    Mailbooth::API
  end

  describe 'GET /api/inboxes' do
    let(:inbox) { double('Inbox', id: '1', name: 'Inbox 1') }
    let(:inbox2) { double('Inbox', id: '2', name: 'Inbox 2') }

    context 'searching for all' do
      let(:params) { {} }

      before do
        allow(Mailbooth::Models::Inbox).to receive(:all).and_return([inbox, inbox2])
        get '/api/inboxes', params
      end

      context 'response status' do
        subject { last_response.status }

        it { is_expected.to be(200) }
      end

      context 'response length' do
        subject { JSON.parse(last_response.body).length }

        it { is_expected.to eq(2) }
      end

      context 'response body' do
        subject { JSON.parse(last_response.body) }

        it { expect(subject[0]['id']).to eq(inbox.id) }
        it { expect(subject[1]['id']).to eq(inbox2.id) }
      end
    end

    context 'searching by auth' do
      let(:params) { { auth: '1111111' } }

      before do
        allow(Mailbooth::Models::Inbox).to receive(:find).with(params).and_return([inbox])
        get '/api/inboxes', params
      end

      context 'response status' do
        subject { last_response.status }

        it { is_expected.to be(200) }
      end

      context 'response length' do
        subject { JSON.parse(last_response.body).length }

        it { is_expected.to eq(1) }
      end

      context 'response body' do
        subject { JSON.parse(last_response.body).first }

        it { expect(subject['id']).to eq(inbox.id) }
        it { expect(subject['name']).to eq(inbox.name) }
      end
    end
  end

  # TODO: Refactor
  describe 'GET /api/inboxes/1/messages' do
    let(:inbox) { double('Inbox', id: '1', messages: []) }
    let(:params) { {} }

    before do
      allow(Mailbooth::Models::Inbox).to receive(:[]).with(inbox.id).and_return(inbox)
    end

    it 'returns all inbox messages' do
      get "/api/inboxes/#{inbox.id}/messages", params

      json_body = JSON.parse(last_response.body)

      expect(last_response.status).to be(200)
      expect(json_body.length).to eq(0)
    end
  end

  describe 'POST /api/inboxes/1/messages' do
    let(:inbox) { instance_double('Inbox', id: '1', name: params[:sender]) }
    let(:message) do
      instance_double(
        'Message',
        id: '1',
        to: 'blah@blah.com',
        from: 'me@sj26.com',
        subject: 'Test mail',
        body: 'Test mail.',
        received_at: Time.now,
        type: 'text/plain'
      )
    end
    let(:params) do
      {
        sender: '<foo@bar.com>',
        recipients: '<foo2@bar.com>, <foo3@bar.com>, <foo4@bar.com>',
        data: "To: Blah <#{message.to}>\r\nFrom: Me <#{message.from}>\r\nSubject: #{message.subject}\r\n\r\n#{message.body}"
      }
    end

    before do
      allow(Mailbooth::Models::Inbox).to receive(:[]).with(inbox.id).and_return(inbox)
      allow(inbox).to receive(:add_message).and_return(message)
      post "/api/inboxes/#{inbox.id}/messages", params
    end

    context 'response status' do
      subject { last_response.status }

      it { is_expected.to be(201) }
    end

    context 'response body' do
      subject { JSON.parse(last_response.body) }

      it { expect(subject['id']).to eq(message.id) }
      it { expect(subject['to']).to eq(message.to) }
      it { expect(subject['from']).to eq(message.from) }
      it { expect(subject['subject']).to eq(message.subject) }
      it { expect(subject['body']).to eq(message.body) }
    end
  end
end
