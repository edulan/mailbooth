require 'grape-entity'

module Mailbooth
  module Entities
    class Message < Grape::Entity
      expose :id, :from,
        :to, :subject,
        :body, :type,
        :received_at
    end
  end
end
