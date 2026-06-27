# frozen_string_literal: true

require './lib/program_result'
require './lib/gem_info'
require './lib/ruby_gems/client'
require './lib/commands/command'
require './lib/errors/missing_gem_name_error'

class SearchCommand < Command
  def initialize(client = RubyGems::Client.new)
    super()
    @client = client
  end

  def execute(args)
    raise MissingGemNameError if args[0].nil?

    response = @client.search(args[0])

    return ProgramResult.new(0, 'No gems were found.') if response.empty?


    description = response
                    .map { |gem| GemInfo.new(gem['name'], gem['info']) }
                    .map { |gem_info| gem_info.to_s }
                    .join("\n")

    ProgramResult.new(0, description)
  end
end
