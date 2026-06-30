# frozen_string_literal: true

require './lib/errors/cli_error'

class ServerError < CLIError
  def initialize
    super(8, 'RubyGems is currently unavailable. Try again later.')
  end
end
