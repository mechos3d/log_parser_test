# frozen_string_literal: true

module LogParser
  class ParseFile
    class Result
      attr_reader :result, :errors

      def initialize(result: '', errors: [])
        @result = result
        @errors = errors
      end
    end
  end
end
