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
        params do
          optional :from, type: String
        end
        get 'messages' do
          inbox = Models::Inbox[params['id']]
          error!('Inbox not found', 404) unless inbox

          if params[:from]
            messages = inbox.messages.find(from: params[:from])
          else
            messages = inbox.messages
          end

          present messages.to_a, with: Entities::Message
        end
      end
    end
  end
end
