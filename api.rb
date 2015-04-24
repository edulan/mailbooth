require 'grape'

require './config/redis'
require './models'
require './entities'

module Mailbooth
  class API < Grape::API
    format :json
    prefix :api

    resource :inboxes do
      desc 'Return all inboxes.'
      params do
        optional :auth, type: String
      end
      get do
        search = {}
        search[:auth] = params[:auth] if params[:auth]

        if !search.empty?
          inboxes = Models::Inbox.find(search)
        else
          inboxes = Models::Inbox.all
        end

        present inboxes.to_a, with: Entities::Inbox
      end

      desc 'Creates an inbox.'
      params do
        optional :name, type: String
      end
      post do
        inbox = Models::Inbox.create(params)

        present inbox, with: Entities::Inbox, show_credentials: true
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

        desc 'Create a message for an inbox'
        params do
          requires :sender, type: String
          requires :recipients, type: String
          requires :data, type: String
        end
        post 'messages' do
          inbox = Models::Inbox[params['id']]
          error!('Inbox not found', 404) unless inbox

          message = inbox.add_message(Models::Message.new(params))

          present message, with: Entities::Message
        end
      end
    end
  end
end
