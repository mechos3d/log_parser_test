# frozen_string_literal: true

require 'spec_helper'

RSpec.describe LogParser::CliEntrypoint do
  subject(:class_call) do
    described_instance.call
  end

  before { allow(described_instance).to receive(:exit_with) }

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

  context 'when given valid file path' do
    let(:argv) { [File.join(__dir__, '..', 'fixtures', 'webserver.log')] }

    before do
      allow(::LogParser::ParseFile).to receive(:call) do
        ::LogParser::ParseFile::Result.new(result: 'result_string', errors: ['errors_string'])
      end
    end

    context 'when FileParse returns success' do
      it 'returns result to stdout' do
        class_call
        expect(stdout).to have_received(:puts).with('result_string')
      end
    end

    context 'when FileParse returns failure' do
      it 'returns error to stderr' do
        class_call
        expect(stderr).to have_received(:puts).with('errors_string')
      end
    end
  end
end
