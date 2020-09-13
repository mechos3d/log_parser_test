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
      raw_data = CollectRawData.new(io: io).call

      string = OutputFormatter.call(data: raw_data)

      if raw_data.empty?
        Result.new(errors: 'An empty file is given')
      else
        Result.new(result: string)
      end
    end

    private

    attr_reader :io
  end
end
