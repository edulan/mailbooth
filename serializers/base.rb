require 'json'

module Mailbooth
  module Serializers
    class Base
      def initialize(object)
        @object = object
      end

      def to_h
        serialize
      end

      def to_hash
        serialize
      end

      protected

      attr_reader :object
    end
  end
end