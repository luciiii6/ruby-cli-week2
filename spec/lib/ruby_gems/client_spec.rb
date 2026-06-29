# frozen_string_literal: true

require './lib/ruby_gems/client'
require './lib/errors/gem_not_found_error'

RSpec.describe RubyGems::Client do
  let(:connection) { instance_double(Faraday::Connection) }
  let(:client) { described_class.new }
  let(:gem_name) { 'rails' }
  let(:response) { instance_double(Faraday::Response, status: status, body: body) }

  before do
    allow(Faraday).to receive(:new)
      .with(url: 'https://rubygems.org/api/v1')
      .and_return(connection)
    allow(connection).to receive(:get).with("gems/#{gem_name}.json").and_return(response)
  end

  describe '#show' do
    subject(:show) { client.show(gem_name) }

    context 'when the gem exists' do
      let(:status) { 200 }
      let(:body)   { fixture('show/rails.json') }

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

    context 'when the gem does not exist' do
      let(:gem_name) { 'nope' }
      let(:status)   { 404 }
      let(:body)     { nil }

      it 'raises GemNotFoundError' do
        expect { show }.to raise_error(GemNotFoundError)
      end
    end
  end

  describe '#search' do
    subject(:search) { client.search(gem_name) }

    let(:response) { instance_double(Faraday::Response, status: status, body: body) }

    before do
      allow(Faraday).to receive(:new)
        .with(url: 'https://rubygems.org/api/v1')
        .and_return(connection)
    end

    context 'when an API key is set' do
      let(:status) { 200 }
      let(:body)   { '[]' }
      let(:headers) { {} }
      let(:api_key) { 'test-api-key' }

      before do
        allow(ENV).to receive(:fetch).with('API_KEY', nil).and_return(api_key)
        allow(connection).to receive(:headers).and_return(headers)
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
      let(:status) { 200 }
      let(:body) { fixture('search/empty.json') }

      before do
        allow(connection).to receive(:get).with('search').and_return(response)
      end

      it 'returns an empty array' do
        result = search
        expect(result).to be_empty
      end
    end

    context 'when a list of gems is returned' do
      let(:status) { 200 }
      let(:body) { fixture('search/rails.json') }

      before do
        allow(connection).to receive(:get).with('search').and_return(response)
      end

      it 'returns a list of gems' do
        result = search
        gem = result.first
        expect(result).not_to be_empty
        expect(gem['name']).to eq 'rails'
      end
    end
  end
end
