require 'grape-entity'

module Mailbooth
  module Entities
    class Message < Grape::Entity
      expose :id, :sender,
        :recipient, :subject,
        :received_at
    end
  end
end
