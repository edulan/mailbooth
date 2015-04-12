require 'ohm'

require './models/message'

module Mailbooth
  module Models
    class Inbox < Ohm::Model
      attribute :name
      set :messages, 'Mailbooth::Models::Message'

      index :name

      def add_message(message)
        messages << message.save
      end
    end
  end
end
