require 'grape'

require './config/redis'
require './app/api/v1'
require './app/api/mailgun'

module Mailbooth
  class App < Grape::API
    mount API::V1 => '/api'
    mount API::Mailgun => '/hooks'
  end
end
