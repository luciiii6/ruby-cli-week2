# frozen_string_literal: true

require 'tmpdir'
require 'fileutils'
require 'json'
require './lib/ruby_gems/cache'

describe RubyGems::Cache do
  subject(:cache) { described_class.new }

  let(:tmpdir) { Dir.mktmpdir }
  let(:key)    { 'rails' }
  let(:path)   { File.join(tmpdir, "#{key}.json") }

  before { stub_const('RubyGems::Cache::CACHE_DIR', tmpdir) }
  after  { FileUtils.remove_entry(tmpdir) }

  describe '.fetch' do
    context 'when the key is not in the cache' do
      it 'writes the new value to the file' do
        cache.fetch(key, '"fresh"')
        expect(File.read(path)).to eq('"fresh"')
      end
    end

    context 'when the key is in the cache' do
      before { cache.fetch(key, '"cached"') }

      context 'when the file is not expired' do
        it 'returns the value from the file' do
          expect(cache.fetch(key, '"ignored"')).to eq('cached')
        end

        it 'updates the file timestamp' do
          File.utime(Time.now - 60, Time.now - 60, path)
          cache.fetch(key, '"ignored"')
          expect(File.mtime(path)).to be_within(2).of(Time.now)
        end
      end

      context 'when the file is expired' do
        before { File.utime(Time.now - 9999, Time.now - 9999, path) }

        it 'writes the new value to the file' do
          cache.fetch(key, '"fresh"')
          expect(File.read(path)).to eq('"fresh"')
        end

        it 'updates the file timestamp' do
          cache.fetch(key, '"fresh"')
          expect(File.mtime(path)).to be_within(2).of(Time.now)
        end
      end
    end
  end
end
