# frozen_string_literal: true

require 'set'
require 'ipaddr'

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
        @result = {}
      end

      def call
        io.each_line.with_index { |line, index| process(line, index) }

        [result.values, errors]
      end

      private

      attr_reader :io, :errors, :result

      def process(line, index)
        elements = line.split(' ')

        if (code = line_error_code(elements))
          errors << LineError.new(index: index, code: code)
        else
          url = elements[0]
          ip  = elements[1]
          result[url] ||= UrlViewDetails.new(url: url)

          result[url].total_views += 1
          result[url].uniq_ips << ip
        end
      end

      def line_error_code(elements)
        return LineError.code(:extra_information) if elements.size > 2

        return LineError.code(:not_enough_information) if elements.size < 2

        ip = elements[1]

        return LineError.code(:invalid_ip) unless valid_ip?(ip)

        nil
      end

      def valid_ip?(ip)
        IPAddr.new(ip)
        true
      rescue IPAddr::InvalidAddressError
        false
      end
    end
  end
end
