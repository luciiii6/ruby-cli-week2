# frozen_string_literal: true

require 'faraday'
require 'json'
require './lib/errors/gem_not_found_error'
require './lib/errors/client_error'
require './lib/errors/server_error'
require './lib/ruby_gems/cache'

module RubyGems
  class Client
    BASE_URL = 'https://rubygems.org/api/v1'
    attr_reader :connection, :cache

    def initialize(cache: Cache.new)
      @connection = Faraday.new(url: BASE_URL) do |connection|
        connection.headers['Authorization'] = ENV.fetch('API_KEY', nil)
        connection.response :raise_error
      end
      @cache = cache
    end

    def show(gem_name)
      cache.fetch("show#{gem_name}") do
        with_error_handling { @connection.get("gems/#{gem_name}.json") }.body
      end
    end

    def search(gem_name)
      cache.fetch("search#{gem_name}") do
        with_error_handling do
          @connection.get('search') do |request|
            request.params = { query: gem_name }
          end
        end.body
      end
    end

    private

    def with_error_handling
      yield
    rescue Faraday::ResourceNotFound
      raise GemNotFoundError
    rescue Faraday::ClientError
      raise ClientError
    rescue Faraday::ServerError
      raise ServerError
    end
  end
end
