require 'grape'

require './models'
require './entities'

module Mailbooth
  class API < Grape::API
    format :json
    prefix :api

    resource :inboxes do
      desc 'Return all inboxes.'
      get do
        inboxes = Models::Inbox.all

        present inboxes.to_a, with: Entities::Inbox
      end

      route_param :id do
        desc 'Returns all messages for an inbox.'
        get 'messages' do
          inbox = Models::Inbox[params['id']]

          error!('Inbox not found', 404) unless inbox

          present inbox.messages.to_a, with: Entities::Message
        end
      end
    end
  end
end
