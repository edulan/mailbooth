require 'grape'

require './app/models/message'
require './app/entities/message'

module Mailbooth
  module API
    class V1 < Grape::API
      version 'v1', using: :header, vendor: 'mailbooth'
      format :json

      resource :messages do
        desc 'Returns all messages for an inbox.'
        params do
          requires :to, type: String
        end
        get do
          search = {
            to: params.to
          }

          search[:subject] = params.subject if params.key?('subject')

          messages = Models::Message.find(search)
          present messages.to_a, with: Entities::Message
        end
      end
    end
  end
end
