# frozen_string_literal: true

require './lib/errors/cli_error'

class UnknownCommandError < CLIError
  def initialize
    super(2, 'Command unknown')
  end
end
