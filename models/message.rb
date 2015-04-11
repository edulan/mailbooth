require 'ohm'

module Mailbooth
  module Models
    class Message < Ohm::Model
      attribute :sender
      attribute :recipient
      attribute :subject
      attribute :source
      attribute :size
      attribute :type
      attribute :received_at
    end
  end
end
