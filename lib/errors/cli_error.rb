# frozen_string_literal: true

class CLIError < StandardError
  attr_reader :exit_code

  def initialize(exit_code, message)
    super(message)
    @exit_code = exit_code
  end
end
