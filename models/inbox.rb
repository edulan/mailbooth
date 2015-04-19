require 'ohm'
require 'ohm/contrib'
require 'digest'
require 'securerandom'

require './models/message'

module Mailbooth
  module Models
    class Inbox < Ohm::Model
      include Ohm::Callbacks

      attribute :name
      attribute :username
      attribute :password
      
      set :messages, 'Mailbooth::Models::Message'

      index :auth

      def add_message(message)
        messages << message.save
        message
      end

      def auth
        Digest::MD5.hexdigest("#{username}:#{password}")
      end

      private

      def before_save
        self.username = SecureRandom.hex(17) unless username
        self.password = SecureRandom.hex(14) unless password
      end
    end
  end
end
