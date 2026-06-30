# frozen_string_literal: true

require './lib/program_result'
require './lib/gem_info'
require './lib/ruby_gems/client'
require './lib/commands/command'
require './lib/errors/missing_gem_name_error'
require './lib/search/search_options_parser'

class SearchCommand < Command
  def initialize(client = RubyGems::Client.new)
    super()
    @client = client
  end

  def execute(args)
    gem_name = args[0]
    raise MissingGemNameError if gem_name.nil?

    options = SearchOptionsParser.parse(args[1..])
    gems = @client.search(gem_name).map { |data| GemInfo.new(data) }
    options.each { |option| gems = option.apply(gems) }

    return ProgramResult.new(0, 'No gems were found.') if gems.empty?

    ProgramResult.new(0, gems.join("\n"))
  end
end
