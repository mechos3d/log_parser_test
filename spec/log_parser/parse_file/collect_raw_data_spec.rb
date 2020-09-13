# frozen_string_literal: true

require 'spec_helper'

RSpec.describe LogParser::ParseFile::CollectRawData do
  subject(:class_call) { described_class.new(io: io).call }

  let(:success_value) { class_call[0] }
  let(:errors)        { class_call[1] }

  context 'when given empty io' do
    let(:io) { StringIO.new('') }

    it 'returns an empty value array' do
      expect(success_value).to eq([])
    end

    it 'returns an empty errors array' do
      expect(errors).to eq([])
    end
  end

  context 'when given valid one-line io' do
    let(:url) { '/foo/' }
    let(:ip) { '111.111.111.111' }
    let(:io) { StringIO.new("#{url} #{ip}") }

    it 'returns a value array with one element' do
      expect(success_value).to eq(
        [described_class::UrlViewDetails.new(url: url, total_views: 1, uniq_ips: Set.new([ip]))]
      )
    end

    it 'returns an empty errors array' do
      expect(errors).to eq([])
    end
  end

  context 'when given lines with two different valid urls' do
    let(:url1) { '/foo/' }
    let(:url2) { '/bar/' }
    let(:ip)   { '111.111.111.111' }
    let(:io) do
      StringIO.new(
        "#{url1} #{ip}\n"\
        "#{url2} #{ip}"
      )
    end

    it 'returns an array with elements for both urls' do
      expect(success_value.map(&:url)).to match_array([url1, url2])
    end

    it 'total_views is equal to 1 for both of urls' do
      aggregate_failures do
        expect(success_value.map(&:total_views)).to eq([1, 1])
      end
    end

    it 'uniq_ips size is equal to 1 for both of urls' do
      aggregate_failures do
        expect(success_value.map { |x| x.uniq_ips.size }).to eq([1, 1])
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
      expect(success_value.size).to eq(1)
    end

    it 'total views is 2' do
      expect(success_value.first.total_views).to eq(2)
    end

    it 'uniq_ips size is 1' do
      expect(success_value.first.uniq_ips.size).to eq(1)
    end
  end
end
