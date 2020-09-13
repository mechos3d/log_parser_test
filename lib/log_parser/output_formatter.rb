# frozen_string_literal: true

module LogParser
  class OutputFormatter
    def self.call(**args)
      new(**args).call
    end

    def initialize(data:)
      @data = data
    end

    def call
      <<~HEREDOC
        --- Most page views: ------------------
        #{most_page_views}

        --- Most unique page views: -----------
        #{most_unique_page_views}

      HEREDOC
    end

    private

    attr_reader :data

    def most_page_views
      data.sort do |el1, el2|
        if el1.total_views == el2.total_views
          el1.url <= el2.url ? -1 : 1
        else
          el1.total_views > el2.total_views ? -1 : 1
        end
      end.map(&:url).join("\n")
    end

    def most_unique_page_views
      data.sort do |el1, el2|
        size1 = el1.uniq_ips.size
        size2 = el2.uniq_ips.size

        if size1 == size2
          el1.url <= el2.url ? -1 : 1
        else
          size1 > size2 ? -1 : 1
        end
      end.map(&:url).join("\n")
    end
  end
end
