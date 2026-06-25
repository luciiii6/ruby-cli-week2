# frozen_string_literal: true

require './lib/errors/cli_error'

class NoCommandError < CLIError
  def initialize
    super(1, 'No command given')
  end
end
