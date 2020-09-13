# frozen_string_literal: true

require 'set'

module LogParser
  class ParseFile
    class CollectRawData
      class UrlViewDetails
        attr_accessor :url, :total_views, :uniq_ips

        def initialize(url:, total_views: 0, uniq_ips: ::Set.new)
          @url         = url
          @total_views = total_views
          @uniq_ips    = uniq_ips
        end

        def ==(other)
          eql?(other)
        end

        def eql?(other)
          url == other.url &&
            total_views == other.total_views &&
            uniq_ips == other.uniq_ips
        end
      end

      def initialize(io:)
        @io     = io
        @errors = []
      end

      def call
        result = {}

        io.each_line do |line|
          url, ip = line.split(' ')

          result[url] ||= UrlViewDetails.new(url: url)

          result[url].total_views += 1
          result[url].uniq_ips << ip
        end

        [result.values, errors]
      end

      private

      attr_reader :io, :errors
    end
  end
end
