# frozen_string_literal: true

class ProgramResult
  attr_reader :exit_code, :exit_description

  def initialize(exit_code, exit_description)
    @exit_code = exit_code
    @exit_description = exit_description
  end
end
