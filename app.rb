require 'sinatra'
require 'sinatra/json'

require './models/inbox'
require './models/mail'

module Mailbooth
  class App < Sinatra::Base
    get '/inbox/:name' do
      inbox = Models::Inbox.find(name: params['name']).first

      json inbox.mails.map do |mail|
        mail.to_hash
      end
    end
  end
end
