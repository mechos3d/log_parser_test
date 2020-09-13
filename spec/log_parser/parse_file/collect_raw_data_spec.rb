# frozen_string_literal: true

require 'spec_helper'

RSpec.describe LogParser::ParseFile::CollectRawData do
  subject(:class_call) { described_instance.call }

  let(:described_instance) { described_class.new(io: io) }

  context 'when given empty io' do
    let(:io) { StringIO.new('') }

    it 'returnes an empty array' do
      expect(class_call).to eq([])
    end
  end

  context 'when given valid one-line io' do
    let(:url) { '/foo/' }
    let(:ip) { '111.111.111.111' }
    let(:io) { StringIO.new("#{url} #{ip}") }

    it 'returns an array with one element' do
      expect(class_call).to eq(
        [described_class::UrlViewDetails.new(url: url, total_views: 1, uniq_ips: Set.new([ip]))]
      )
    end
  end

  context 'when given lines with two different valid urls' do
    let(:url1) { '/foo/' }
    let(:url2) { '/bar/' }
    let(:ip) { '111.111.111.111' }
    let(:io) do
      StringIO.new(
        "#{url1} #{ip}\n"\
        "#{url2} #{ip}"
      )
    end

    it 'returns an array with elements for both urls' do
      expect(class_call.map(&:url)).to match_array([url1, url2])
    end

    it 'total_views is equal to 1 for both of urls' do
      aggregate_failures do
        expect(class_call.map(&:total_views)).to eq([1, 1])
      end
    end

    it 'uniq_ips size is equal to 1 for both of urls' do
      aggregate_failures do
        expect(class_call.map { |x| x.uniq_ips.size }).to eq([1, 1])
      end
    end
  end

  context 'when given two lines with the same valid url and same ip-addresses' do
    let(:url) { '/foo/' }
    let(:ip) { '111.111.111.111' }
    let(:io) do
      StringIO.new(
        "#{url} #{ip}\n"\
        "#{url} #{ip}"
      )
    end

    it 'returnes a one element array' do
      expect(class_call.size).to eq(1)
    end

    it 'total views is 2' do
      expect(class_call.first.total_views).to eq(2)
    end

    it 'uniq_ips size is 1' do
      expect(class_call.first.uniq_ips.size).to eq(1)
    end
  end
end
