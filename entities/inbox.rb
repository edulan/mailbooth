require 'grape-entity'

module Mailbooth
  module Entities
    class Inbox < Grape::Entity
      expose :id, :name
    end
  end
end
