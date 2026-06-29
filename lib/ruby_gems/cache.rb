# frozen_string_literal: true

require 'fileutils'
module RubyGems
  class Cache
    CACHE_DIR = ENV['APP_ENV'] == 'test' ? './tmp/test_cache' : './tmp/cache'
    CACHE_PATH = ->(key) { "#{CACHE_DIR}/#{key}.json" }
    DEFAULT_EXPIRY = 2 * 60 * 60

    def initialize
      FileUtils.mkdir_p(CACHE_DIR)
    end

    def fetch(key, expires_in: DEFAULT_EXPIRY)
      path = CACHE_PATH.call(key)
      if hit?(path, expires_in)
        update_timestamp(path)
      else
        write(path, yield)
      end

      read(path)
    end

    def clear
      FileUtils.rm_rf(CACHE_DIR)
      FileUtils.mkdir_p(CACHE_DIR)
    end

    private

    def hit?(path, expires_in)
      File.exist?(path) && Time.now - File.mtime(path) < expires_in
    end

    def update_timestamp(path)
      FileUtils.touch(path)
    end

    def write(path, value)
      File.write(path, value)
    end

    def read(path)
      JSON.parse(File.read(path))
    end
  end
end
