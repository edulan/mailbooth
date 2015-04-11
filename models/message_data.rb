module Mailbooth
  module Models
    class MessageData
      def initialize(data)
        @data = data
      end

      def subject
        subject_line = data.map { |line| line.match(/^Subject:\s(.*)$/) }.compact.first
        subject_line.captures.first if subject_line
      end

      def source
        data.map { |line| "#{line}\r\n" }
      end

      private

      attr_reader :data
    end
  end
end
