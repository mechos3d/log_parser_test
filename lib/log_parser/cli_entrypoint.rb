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

      path_to_file = argv.first
      return 2 if file_doesnt_exist(path_to_file)

      result = ParseFile.call(io: File.new(path_to_file))

      stdout.puts(result.result)
      stderr.puts(result.errors)

      result.errors.empty? ? 0 : 3
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

    def file_doesnt_exist(path_to_file)
      return if File.exist?(path_to_file)

      stderr.puts('File does not exist')
      true
    end
  end
end
