require 'ohm'

module Mailbooth
  module Models
    class Message < Ohm::Model
      attribute :from
      attribute :to
      attribute :subject
      attribute :body
      attribute :text_body
      attribute :html_body
      attribute :type
      attribute :received_at

      index :subject
      index :from
      index :to
    end
  end
end
