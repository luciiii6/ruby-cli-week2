# frozen_string_literal: true

require './lib/errors/cli_error'

class GemNotFoundError < CLIError
  def initialize
    super(4, 'Gem not found')
  end
end
