require 'spec_helper'

require 'rack/test'
require './api'

RSpec.describe Mailbooth::API do
  include Rack::Test::Methods

  def app
    Mailbooth::API
  end

  describe 'GET /api/inboxes' do
    let(:inboxes) do
      (1..3).map do |i|
        double('Inbox', id: "#{i}", name: "Inbox #{i}")
      end
    end

    context 'searching for all' do
      let(:params) { {} }

      before do
        allow(Mailbooth::Models::Inbox).to receive(:all).and_return(inboxes)
        get '/api/inboxes', params
      end

      context 'response status' do
        subject { last_response.status }

        it { is_expected.to be(200) }
      end

      context 'response length' do
        subject { JSON.parse(last_response.body).length }

        it { is_expected.to eq(inboxes.length) }
      end

      context 'response body' do
        subject { JSON.parse(last_response.body) }

        it do
          inboxes.each_with_index do |inbox, index|
            expect(subject[index]['id']).to eq(inbox.id)
          end
        end
      end
    end

    context 'searching by auth' do
      let(:inbox) { inboxes.first }
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

  describe 'POST /api/inboxes' do
    let(:inbox) do
      instance_double('Inbox',
                      id: '1',
                      name: params[:name],
                      username: '123456',
                      password: '123456'
      )
    end
    let(:params) do
      {
        name: '<foo@bar.com>'
      }
    end

    before do
      allow(Mailbooth::Models::Inbox).to receive(:create).with(params).and_return(inbox)
      post '/api/inboxes', params
    end

    context 'response status' do
      subject { last_response.status }

      it { is_expected.to be(201) }
    end

    context 'response body' do
      subject { JSON.parse(last_response.body) }

      it { expect(subject['id']).to eq(inbox.id) }
      it { expect(subject['name']).to eq(inbox.name) }
      it { expect(subject['username']).to eq(inbox.username) }
      it { expect(subject['password']).to eq(inbox.password) }
    end
  end

  describe 'GET /api/inboxes/1/messages' do
    let(:inbox) { double('Inbox', id: '1', name: '<foo@bar.com>') }
    let(:messages) do
      (1..3).map do |i|
        instance_double(
          'Message',
          id: "#{i}",
          to: 'blah@blah.com',
          from: 'me@sj26.com',
          subject: 'Test mail',
          body: 'Test mail.',
          received_at: Time.now,
          type: 'text/plain'
        )
      end
    end
    let(:params) { {} }

    before do
      allow(Mailbooth::Models::Inbox).to receive(:[]).with(inbox.id).and_return(inbox)
      allow(inbox).to receive(:messages).and_return(messages)
      get '/api/inboxes/1/messages', params
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
      subject { JSON.parse(last_response.body) }

      it do
        messages.each_with_index do |message, index|
          expect(subject[index]['id']).to eq(message.id)
        end
      end
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
