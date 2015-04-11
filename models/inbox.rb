require 'ohm'
require './models/message'

module Mailbooth
  module Models
    class Inbox < Ohm::Model
      attribute :name
      list :messages, 'Mailbooth::Models::Message'

      index :name

      def add_message(message)
        messages.push(message.save)
      end
    end
  end
end
