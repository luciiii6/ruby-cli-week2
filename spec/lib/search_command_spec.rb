# frozen_string_literal: true

require 'json'
require './lib/commands/search_command'
require './lib/errors/missing_gem_name_error'
require './lib/errors/gem_not_found_error'

RSpec.describe SearchCommand do
  subject(:execute) { command.execute(args) }

  let(:client) { instance_double(RubyGems::Client) }
  let(:command) { described_class.new(client) }
  let(:args) { [] }

  describe '#execute' do
    context 'when args are empty' do
      it 'raises MissingGemNameError' do
        expect { execute }.to raise_error(MissingGemNameError)
      end
    end

    context 'when no gems are returned' do
      let(:args) { ['test'] }
      let(:response) { JSON.parse(fixture('search/empty.json')) }

      before do
        allow(client).to receive(:search).with('test').and_return(response)
      end

      it 'returns a generic description' do
        result = execute

        expect(result.exit_code).to eq 0
        expect(result.exit_description).to eq 'No gems were found.'
      end
    end

    context 'gems are returned' do
      let(:args) { ['rails'] }
      let(:response) { JSON.parse(fixture('search/rails.json')) }

      before do
        allow(client).to receive(:search).with('rails').and_return(response)
      end

      it 'returns rails gem' do
        result = execute

        expect(result.exit_code).to eq 0
      end
    end

    context 'when --license is passed' do
      let(:args) { ['rails', '--license', 'MIT'] }
      let(:response) do
        [
          { 'name' => 'rails',  'info' => 'web', 'licenses' => ['MIT'] },
          { 'name' => 'other',  'info' => 'x',   'licenses' => ['BSD'] }
        ]
      end

      before do
        allow(client).to receive(:search).with('rails').and_return(response)
      end

      it 'only shows gems with the matching license' do
        result = execute

        expect(result.exit_description).to include('rails')
        expect(result.exit_description).not_to include('other')
      end
    end
  end
end
