require 'spec_helper'

require 'rack/test'
require './api'

RSpec.describe Mailbooth::API do
  include Rack::Test::Methods

  def app
    Mailbooth::API
  end

  describe 'GET /api/inboxes' do
    before do
      inbox = double('Inbox', id: 1, name: 'foo@bar.com')
      allow(Mailbooth::Models::Inbox).to receive(:all).and_return([inbox])
    end

    it 'returns all inboxes' do
      get '/api/inboxes'

      json_body = JSON.parse(last_response.body)

      expect(last_response.status).to be(200)
      expect(json_body.length).to eq(1)
      expect(json_body[0]['id']).to eq(1)
      expect(json_body[0]['name']).to eq('foo@bar.com')
    end
  end

  describe 'GET /api/inboxes/1/messages' do
    let(:inbox_id) { 1 }
    let(:params) { {} }

    before do
      inbox = double('Inbox', id: inbox_id, messages: [])
      allow(Mailbooth::Models::Inbox).to receive(:[]).with(inbox_id.to_s).and_return(inbox)
    end

    it 'returns all inboxes' do
      get "/api/inboxes/#{inbox_id}/messages", params

      json_body = JSON.parse(last_response.body)

      expect(last_response.status).to be(200)
      expect(json_body.length).to eq(0)
    end
  end
end
