# frozen_string_literal: true

require 'spec_helper'

RSpec.describe LogParser::CliEntrypoint do
  subject(:class_call) do
    described_instance.call
  end

  before { allow(described_instance).to receive(:exit_with) }

  let(:described_instance) do
    described_class.new(argv: argv, stdout: stdout, stderr: stderr)
  end

  let(:stdout) { double.tap { |dbl| allow(dbl).to receive(:puts) } }
  let(:stderr) { double.tap { |dbl| allow(dbl).to receive(:puts) } }
  let(:argv)   { [File.join(__dir__, '..', 'fixtures', 'webserver.log')] }

  it do
    class_call
    expect(stdout).to have_received(:puts).with(<<~HEREDOC)
      --- Most page views: ------------------
      /url/1
      /url/2

      --- Most unique page views: -----------
      /url/2
      /url/1
    HEREDOC

    expect(stderr).not_to have_received(:puts)
  end
end
