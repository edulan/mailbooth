require 'ohm'
require './models/mail'

module Mailbooth
  module Models
    class Inbox < Ohm::Model
      attribute :name
      list :mails, 'Mailbooth::Models::Mail'

      index :name

      def add_mail(mail)
        mails.push(mail.save)
      end
    end
  end
end
