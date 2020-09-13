# frozen_string_literal: true

require 'spec_helper'

RSpec.describe LogParser::ParseFile do
  subject(:class_call) { described_instance.call }

  let(:described_instance) { described_class.new(io: io) }

  context 'when given an empty io' do
    let(:io) { StringIO.new('') }

    it 'returns an empty result string' do
      expect(class_call.result).to be_empty
    end

    it 'returns non-empty errors array' do
      expect(class_call.errors).to eq(['No valid pairs of url+ip found'])
    end
  end

  context 'when given one valid line' do
    let(:io) { StringIO.new('url 111.111.111.111') }

    it 'returns result string' do
      expect(class_call.result).not_to be_empty
    end

    it 'returns an empty errors array' do
      expect(class_call.errors).to eq([])
    end
  end
end
