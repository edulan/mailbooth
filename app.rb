require 'json'
require 'sinatra'
require 'sinatra/json'

require './models/inbox'
require './models/message'
require './serializers/inbox_collection'
require './serializers/message_collection'

module Mailbooth
  class App < Sinatra::Base
    get '/inboxes' do
      inboxes = Models::Inbox.all

      json Serializers::InboxCollection.new(inboxes).serialize
    end

    get '/inboxes/:id/messages' do
      inbox = Models::Inbox[params['id']]

      return not_found unless inbox

      json Serializers::MessageCollection.new(inbox.messages).serialize
    end

    def not_found
      404
    end
  end
end
