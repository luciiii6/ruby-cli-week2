# frozen_string_literal: true

require 'json'
require './lib/commands/show_command'
require './lib/errors/missing_gem_name_error'
require './lib/errors/gem_not_found_error'

RSpec.describe ShowCommand do
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

    context 'when the client raises GemNotFoundError' do
      let(:args) { ['nope'] }

      before { allow(client).to receive(:show).with('nope').and_raise(GemNotFoundError) }

      it 'propagates the error' do
        expect { execute }.to raise_error(GemNotFoundError)
      end
    end

    context 'when the gem exists' do
      let(:args) { ['rails'] }
      let(:rails_data) { JSON.parse(fixture('rails.json')) }

      before { allow(client).to receive(:show).with('rails').and_return(rails_data) }

      it 'returns exit code 0' do
        expect(execute.exit_code).to eq(0)
      end

      it 'prints the gem name and info' do
        expect(execute.exit_description).to eq(
          "Gem name: #{rails_data['name']}\nGem info: #{rails_data['info']}"
        )
      end
    end
  end
end
