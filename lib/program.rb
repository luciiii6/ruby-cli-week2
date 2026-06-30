# frozen_string_literal: true

require './lib/program_result'
require './lib/commands/command_factory'
require './lib/errors/cli_error'
require './lib/errors/no_command_error'

class Program
  def execute(args)
    raise NoCommandError if args.empty?

    CommandFactory.create(args[0]).execute(args[1..])
  rescue CLIError => e
    ProgramResult.new(e.exit_code, e.message)
  end
end
