# frozen_string_literal: true

require './lib/program_result'
require './lib/gem_info'
require './lib/ruby_gems/client'
require './lib/commands/command'
require './lib/errors/missing_gem_name_error'

class ShowCommand < Command
  def initialize(client = RubyGems::Client.new)
    super()
    @client = client
  end

  def execute(args)
    gem_name = args.first
    raise MissingGemNameError if gem_name.nil?

    response = @client.show(gem_name)
    gem = GemInfo.new(response['name'], response['info'])
    ProgramResult.new(0, "Gem name: #{gem.name}\nGem info: #{gem.info}")
  end
end
