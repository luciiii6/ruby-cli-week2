# frozen_string_literal: true

require './lib/commands/show_command'
require './lib/commands/search_command'
require './lib/errors/unknown_command_error'

class CommandFactory
  COMMANDS = {
    'show' => ShowCommand,
    'search' => SearchCommand
  }.freeze

  def self.create(name)
    command_class = COMMANDS[name] || raise(UnknownCommandError)
    command_class.new
  end
end
