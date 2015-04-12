require 'grape'

require './models/inbox'
require './models/message'
require './serializers/inbox_collection'
require './serializers/message_collection'

module Mailbooth
  class API < Grape::API
    format :json
    prefix :api

    resource :inboxes do
      desc 'Return all inboxes.'
      get do
        inboxes = Models::Inbox.all

        Serializers::InboxCollection.new(inboxes).serialize
      end

      route_param :id do
        desc 'Returns all messages for an inbox.'
        get 'messages' do
          inbox = Models::Inbox[params['id']]

          error!('Inbox not found', 404) unless inbox

          Serializers::MessageCollection.new(inbox.messages).serialize
        end
      end
    end
  end
end
