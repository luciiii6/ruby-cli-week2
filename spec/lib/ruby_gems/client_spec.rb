# frozen_string_literal: true

require './lib/ruby_gems/client'
require './lib/errors/gem_not_found_error'

RSpec.describe RubyGems::Client do
  subject(:show) { client.show(gem_name) }

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
    context 'when the gem exists' do
      let(:status) { 200 }
      let(:body)   { fixture('rails.json') }

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
end
