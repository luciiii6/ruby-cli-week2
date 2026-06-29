# frozen_string_literal: true

require 'faraday'
require 'json'
require './lib/errors/gem_not_found_error'
require './lib/ruby_gems/cache'

module RubyGems
  class Client
    BASE_URL = 'https://rubygems.org/api/v1'
    attr_reader :connection, :cache

    def initialize(cache: Cache.new)
      @connection = Faraday.new(url: BASE_URL) do |connection|
        connection.headers['Authorization'] = ENV.fetch('API_KEY', nil)
      end
      @cache = cache
    end

    def show(gem_name)
      cache.fetch("show#{gem_name}") do
        response = @connection.get("gems/#{gem_name}.json")
        raise GemNotFoundError if response.status == 404

        response.body
      end
    end

    def search(gem_name)
      cache.fetch("search#{gem_name}") do
        response = @connection.get('search') do |request|
          request.params = { query: gem_name }
        end

        response.body
      end
    end
  end
end
