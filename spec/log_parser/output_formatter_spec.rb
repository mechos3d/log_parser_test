# frozen_string_literal: true

require 'spec_helper'

RSpec.describe LogParser::OutputFormatter do
  subject(:class_call) { described_class.call(data: data) }

  url_details_class = LogParser::ParseFile::CollectRawData::UrlViewDetails

  context 'when given one url' do
    let(:data) do
      [url_details_class.new(url: '/abc', total_views: 1, uniq_ips: ['111.111.111.111'])]
    end

    it 'returns formatted string' do
      expect(class_call).to eq(
        <<~HEREDOC
          --- Most page views: ------------------
          /abc

          --- Most unique page views: -----------
          /abc

        HEREDOC
      )
    end
  end

  context 'when given two urls with equal total_views and same number of uniq_ips' do
    let(:data) do
      [
        url_details_class.new(url: '/abc', total_views: 1, uniq_ips: ['111.111.111.111']),
        url_details_class.new(url: '/efg', total_views: 1, uniq_ips: ['111.111.111.111'])
      ]
    end

    it 'returns list of urls sorted alphabetically' do
      expect(class_call).to eq(
        <<~HEREDOC
          --- Most page views: ------------------
          /abc
          /efg

          --- Most unique page views: -----------
          /abc
          /efg

        HEREDOC
      )
    end
  end

  context 'when given two urls with different total_views and same number of uniq_ips' do
    let(:data) do
      [
        url_details_class.new(url: '/abc', total_views: 1, uniq_ips: ['111.111.111.111']),
        url_details_class.new(url: '/efg', total_views: 2, uniq_ips: ['111.111.111.111'])
      ]
    end

    it 'returns list sorted by total_views from most page_views to less page views' do
      expect(class_call).to eq(
        <<~HEREDOC
          --- Most page views: ------------------
          /efg
          /abc

          --- Most unique page views: -----------
          /abc
          /efg

        HEREDOC
      )
    end
  end

  context 'when given two urls with equal total_views but different number of uniq_ips' do
    let(:data) do
      [
        url_details_class.new(url: '/abc', total_views: 2, uniq_ips: ['111.111.111.111']),
        url_details_class.new(url: '/efg', total_views: 2, uniq_ips: ['111.111.111.111', '222.222.222.222'])
      ]
    end

    it 'returns list sorted by total_views from most page_views to less page views' do
      expect(class_call).to eq(
        <<~HEREDOC
          --- Most page views: ------------------
          /abc
          /efg

          --- Most unique page views: -----------
          /efg
          /abc

        HEREDOC
      )
    end
  end
end
