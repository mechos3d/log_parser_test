# frozen_string_literal: true

module LogParser
  class CliEntrypoint
    ERROR_CODES = {
      invalid_arguments_number: 1,
      file_doesnt_exist:        2,
      parse_errors_present:     3
    }.freeze
    private_constant :ERROR_CODES

    def initialize(argv: ARGV, stdout: $stdout, stderr: $stderr)
      @argv   = argv
      @stdout = stdout
      @stderr = stderr
    end

    def call
      return exit_with(invalid_input_error_code) if invalid_input_error_code

      result = ParseFile.call(io: File.new(path_to_file))

      stdout.puts(result.result)
      stderr.puts(result.errors)

      result.errors.empty? ? exit_with(0) : exit_with(ERROR_CODES[:parse_errors_present])
    end

    private

    attr_reader :argv, :stdout, :stderr

    def exit_with(code)
      exit(code)
    end

    def path_to_file
      argv.first
    end

    def invalid_input_error_code
      @invalid_input_error_code ||= begin
        if invalid_arguments_number
          ERROR_CODES[:invalid_arguments_number]
        elsif file_doesnt_exist(path_to_file)
          ERROR_CODES[:file_doesnt_exist]
        end
      end
    end

    def invalid_arguments_number
      error = if argv.empty?
                'No filepath given.'
              elsif argv.size > 1
                'Too many arguments given'
              end
      return unless error

      # TODO: need to refactor this: it's bad that method 'invalid_arguments_number'
      # writes to stderr as a side-effect instead of just determining the error_code
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
