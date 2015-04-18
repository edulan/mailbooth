require 'spec_helper'

require 'rack/test'
require './api'

RSpec.describe Mailbooth::API do
  include Rack::Test::Methods

  def app
    Mailbooth::API
  end

  describe 'GET /api/inboxes' do
    let(:inbox) { double('Inbox', id: '1', name: '<foo@bar.com>') }

    before do
      allow(Mailbooth::Models::Inbox).to receive(:all).and_return([inbox])
    end

    it 'returns all inboxes' do
      get '/api/inboxes'

      json_body = JSON.parse(last_response.body)

      expect(last_response.status).to be(200)
      expect(json_body.length).to eq(1)
      expect(json_body[0]['id']).to eq(inbox.id)
      expect(json_body[0]['name']).to eq(inbox.name)
    end
  end

  describe 'GET /api/inboxes/1/messages' do
    let(:inbox) { double('Inbox', id: '1', messages: []) }
    let(:params) { {} }

    before do
      allow(Mailbooth::Models::Inbox).to receive(:[]).with(inbox.id).and_return(inbox)
    end

    it 'returns all inboxes' do
      get "/api/inboxes/#{inbox.id}/messages", params

      json_body = JSON.parse(last_response.body)

      expect(last_response.status).to be(200)
      expect(json_body.length).to eq(0)
    end
  end

  describe 'POST /api/inboxes/1/messages' do
    let(:inbox) { double('Inbox', id: '1', name: params[:sender]) }
    let(:params) do
      {
        sender: '<foo@bar.com>',
        recipients: '<foo2@bar.com>, <foo3@bar.com>, <foo4@bar.com>',
        data: "To: Blah <blah@blah.com>\r\nFrom: Me <me@sj26.com>\r\nSubject: Test mail\r\n\r\nTest mail."
      }
    end

    before do
      allow(Mailbooth::Models::Inbox).to receive(:all).and_return([inbox])
    end

    it 'returns all inboxes' do
      post "/api/inboxes/#{inbox.id}/messages", params

      json_body = JSON.parse(last_response.body)

      expect(last_response.status).to be(201)
      expect(json_body['id']).to eq('1')
    end
  end
end
