# frozen_string_literal: true

require './lib/errors/cli_error'

class MissingGemNameError < CLIError
  def initialize
    super(3, 'No gem name given')
  end
end
