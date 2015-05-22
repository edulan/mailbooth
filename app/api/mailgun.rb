require 'grape'

require './lib/mailgun_webhook'
require './app/models/message'

module Mailbooth
  module API
    class Mailgun < Grape::API
      format :json

      helpers do
        def webhook
          @webhook ||= MailgunWebhook.new(ENV['MAILGUN_API_KEY'])
        end

        def verify!
          # Mailgun expects a 406 to not retry the request
          error!('406 Not Acceptable', 406) unless webhook.verify(params)
        end
      end

      resource :mailgun do
        desc 'Mailgun webhooks'
        post do
          verify!

          message = Models::Message.new({
            to: params.to,
            subject: params.subject
          })
          message.save

          status 200
        end
      end
    end
  end
end
