# frozen_string_literal: true

require './lib/errors/cli_error'

class ClientError < CLIError
  def initialize
    super(7, 'The request was rejected by RubyGems.')
  end
end
