# frozen_string_literal: true

require './lib/commands/command_factory'
require './lib/commands/show_command'
require './lib/errors/unknown_command_error'

RSpec.describe CommandFactory do
  describe '.find' do
    it 'returns a ShowCommand for "show"' do
      expect(described_class.find('show')).to be_a(ShowCommand)
    end

    it 'raises UnknownCommandError for an unknown command' do
      expect { described_class.find('unknown') }.to raise_error(UnknownCommandError)
    end
  end
end
