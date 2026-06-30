# frozen_string_literal: true

require './lib/errors/cli_error'

class InvalidOptionError < CLIError
  def initialize(message)
    super(6, message)
  end
end
