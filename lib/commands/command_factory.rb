# frozen_string_literal: true

require './lib/commands/show_command'
require './lib/commands/search_command'
require './lib/errors/unknown_command_error'

class CommandFactory
  COMMANDS = {
    'show' => ShowCommand.new,
    'search' => SearchCommand.new
  }.freeze

  def self.find(name)
    COMMANDS[name] || raise(UnknownCommandError)
  end
end
