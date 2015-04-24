require 'grape-entity'

module Mailbooth
  module Entities
    class Inbox < Grape::Entity
      expose :id, :name
      expose :username, :password, if: :show_credentials
    end
  end
end
