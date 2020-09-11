# frozen_string_literal: true

require 'spec_helper'

RSpec.describe LogParser::CliEntrypoint do
  subject(:class_call) do
    described_instance.call
  end

  before { allow(described_instance).to receive(:exit) }

  let(:argv) { [] }
  let(:stdout) { double.tap { |dbl| allow(dbl).to receive(:puts) } }
  let(:stderr) { double.tap { |dbl| allow(dbl).to receive(:puts) } }

  let(:described_instance) do
    described_class.new(argv: argv, stdout: stdout, stderr: stderr)
  end

  context 'when called without arguments' do
    it 'returns an error to stderr' do
      class_call
      expect(stderr).to have_received(:puts).with('No filepath given.')
    end
  end

  context 'when called with two arguments' do
    let(:argv) { %w[foo bar] }

    it 'returns an error to stderr' do
      class_call
      expect(stderr).to have_received(:puts).with('Too many arguments given')
    end
  end

  context 'when given a path to non-existent file' do
    let(:argv) { ['/path/to/non/existent/file'] }

    it 'returns an error to stderr' do
      class_call
      expect(stderr).to have_received(:puts).with('File does not exist')
    end
  end
end
