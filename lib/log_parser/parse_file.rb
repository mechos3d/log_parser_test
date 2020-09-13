# frozen_string_literal: true

module LogParser
  class ParseFile
    def self.call(**args)
      new(args).call
    end

    def initialize(io:)
      @io = io
    end

    def call
      raw_data, errors = CollectRawData.new(io: io).call
      return Result.new(errors: ['No valid pairs of url+ip found']) if raw_data.empty?

      string = OutputFormatter.call(data: raw_data)

      Result.new(result: string, errors: errors)
    end

    private

    attr_reader :io
  end
end
