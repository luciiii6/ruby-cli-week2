# frozen_string_literal: true

require 'faraday'
require 'json'
require './lib/errors/gem_not_found_error'

module RubyGems
  class Client
    BASE_URL = 'https://rubygems.org/api/v1'

    def initialize
      @connection = Faraday.new(url: BASE_URL)
    end

    def show(gem_name)
      response = @connection.get("gems/#{gem_name}.json")
      raise GemNotFoundError if response.status == 404

      JSON.parse(response.body)
    end
  end
end
