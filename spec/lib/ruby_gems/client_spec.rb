# frozen_string_literal: true

require './lib/ruby_gems/client'
require './lib/ruby_gems/cache'
require './lib/errors/gem_not_found_error'
require './lib/errors/client_error'
require './lib/errors/server_error'

RSpec.describe RubyGems::Client do
  let(:connection) { instance_double(Faraday::Connection) }
  let(:cache) { instance_double(RubyGems::Cache) }
  let(:client) { described_class.new(cache: cache) }
  let(:gem_name) { 'rails' }
  let(:body) { '{}' }
  let(:response) { instance_double(Faraday::Response, body: body) }

  before do
    allow(Faraday).to receive(:new)
      .with(url: 'https://rubygems.org/api/v1')
      .and_return(connection)
    allow(cache).to receive(:fetch) { |_key, &block| JSON.parse(block.call) }
  end

  describe '#show' do
    subject(:show) { client.show(gem_name) }

    before do
      allow(connection).to receive(:get).with("gems/#{gem_name}.json").and_return(response)
    end

    context 'when the gem exists' do
      let(:body) { fixture('show/rails.json') }

      it 'returns the gem name' do
        expect(show['name']).to eq('rails')
      end

      it 'returns the gem info' do
        expect(show['info']).to start_with('Ruby on Rails is a full-stack web framework')
      end

      it 'returns the licenses' do
        expect(show['licenses']).to eq(['MIT'])
      end
    end

    context 'when the gem is not found' do
      before do
        allow(connection).to receive(:get)
          .with("gems/#{gem_name}.json")
          .and_raise(Faraday::ResourceNotFound, 'not found')
      end

      it 'raises GemNotFoundError' do
        expect { show }.to raise_error(GemNotFoundError)
      end
    end

    context 'when the request is a client error' do
      before do
        allow(connection).to receive(:get)
          .with("gems/#{gem_name}.json")
          .and_raise(Faraday::ClientError, 'bad request')
      end

      it 'raises ClientError' do
        expect { show }.to raise_error(ClientError)
      end
    end

    context 'when the server fails' do
      before do
        allow(connection).to receive(:get)
          .with("gems/#{gem_name}.json")
          .and_raise(Faraday::ServerError, 'boom')
      end

      it 'raises ServerError' do
        expect { show }.to raise_error(ServerError)
      end
    end
  end

  describe '#search' do
    subject(:search) { client.search(gem_name) }

    before do
      allow(connection).to receive(:get).with('search').and_return(response)
    end

    context 'when an API key is set' do
      let(:body) { '[]' }
      let(:headers) { {} }
      let(:api_key) { 'test-api-key' }

      before do
        allow(ENV).to receive(:fetch).with('API_KEY', nil).and_return(api_key)
        allow(connection).to receive(:headers).and_return(headers)
        allow(connection).to receive(:response).with(:raise_error)
        allow(Faraday).to receive(:new)
          .with(url: 'https://rubygems.org/api/v1')
          .and_yield(connection)
          .and_return(connection)
      end

      it 'sets the Authorization header on the connection' do
        client
        expect(headers['Authorization']).to eq('test-api-key')
      end
    end

    context 'when no gem exists with this name' do
      let(:body) { fixture('search/empty.json') }

      it 'returns an empty array' do
        expect(search).to be_empty
      end
    end

    context 'when a list of gems is returned' do
      let(:body) { fixture('search/rails.json') }

      it 'returns a list of gems' do
        expect(search).not_to be_empty
      end

      it 'returns gems with the right name' do
        expect(search.first['name']).to eq('rails')
      end
    end

    context 'when the server fails' do
      before do
        allow(connection).to receive(:get).with('search').and_raise(Faraday::ServerError, 'boom')
      end

      it 'raises ServerError' do
        expect { search }.to raise_error(ServerError)
      end
    end
  end
end
