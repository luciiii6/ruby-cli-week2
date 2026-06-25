# frozen_string_literal: true

require './lib/commands/show_command'
require './lib/errors/unknown_command_error'

class CommandFactory
  COMMANDS = {
    'show' => ShowCommand.new
  }.freeze

  def self.find(name)
    COMMANDS[name] || raise(UnknownCommandError)
  end
end
