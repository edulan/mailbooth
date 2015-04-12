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
          optional :to, type: String
        end
        get 'messages' do
          inbox = Models::Inbox[params['id']]
          error!('Inbox not found', 404) unless inbox

          search = {}
          search[:from] = params[:from] if params[:from]
          search[:to] = params[:to] if params[:to]

          if !search.empty?
            messages = inbox.messages.find(search)
          else
            messages = inbox.messages
          end

          present messages.to_a, with: Entities::Message
        end
      end
    end
  end
end
