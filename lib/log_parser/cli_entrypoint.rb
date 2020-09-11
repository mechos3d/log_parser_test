# frozen_string_literal: true

module LogParser
  class CliEntrypoint
    def initialize(argv: ARGV, stdout: $stdout, stderr: $stderr)
      @argv   = argv
      @stdout = stdout
      @stderr = stderr
    end

    def call
      return 1 if invalid_arguments_number

      file_name = argv.first
      return 2 if file_doesnt_exist(file_name)
    end

    private

    attr_reader :argv, :stdout, :stderr

    def invalid_arguments_number
      error = if argv.empty?
                'No filepath given.'
              elsif argv.size > 1
                'Too many arguments given'
              end
      return unless error

      stderr.puts(error)
      true
    end

    def file_doesnt_exist(file_name)
      return if File.exist?(file_name)

      stderr.puts('File does not exist')
      true
    end
  end
end
