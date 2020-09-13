# frozen_string_literal: true

module LogParser
  class ParseFile
    class LineError
      attr_reader :index, :code

      CODES = {
        not_enough_information: :not_enough_information,
        invalid_ip:             :invalid_ip,
        extra_information:      :extra_information
      }.freeze

      def self.code(token)
        CODES.fetch(token)
      end

      def initialize(index:, code:)
        @index = index
        @code  = code
      end

      def ==(other)
        eql?(other)
      end

      def eql?(other)
        index == other.index &&
          code == other.code
      end

      def to_s
        "line number: #{index}, #{code}"
      end
    end
  end
end
