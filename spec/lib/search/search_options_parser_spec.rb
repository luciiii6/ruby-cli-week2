# frozen_string_literal: true

require './lib/search/search_options_parser'
require './lib/search/options/license_option'
require './lib/search/options/most_downloads_first_option'
require './lib/errors/invalid_option_error'

RSpec.describe SearchOptionsParser do
  subject(:parse) { described_class.parse(args) }

  describe '.parse' do
    context 'when no flags are given' do
      let(:args) { [] }

      it 'returns an empty option list' do
        expect(parse).to be_empty
      end
    end

    context 'when --license is given' do
      let(:args) { ['--license', 'MIT'] }

      it 'returns one LicenseOption' do
        expect(parse).to all(be_a(LicenseOption))
      end

      it 'returns exactly one option' do
        expect(parse.size).to eq(1)
      end
    end

    context 'when --most-downloads-first is given' do
      let(:args) { ['--most-downloads-first'] }

      it 'returns a MostDownloadsFirstOption' do
        expect(parse).to all(be_a(MostDownloadsFirstOption))
      end
    end

    context 'when both options are given' do
      let(:args) { ['--license', 'MIT', '--most-downloads-first'] }

      it 'returns both options in order' do
        expect(parse.map(&:class)).to eq([LicenseOption, MostDownloadsFirstOption])
      end
    end

    context 'when an unknown flag is given' do
      let(:args) { ['--bogus'] }

      it 'raises InvalidOptionError' do
        expect { parse }.to raise_error(InvalidOptionError, /invalid option/)
      end
    end

    context 'when --license is given without a value' do
      let(:args) { ['--license'] }

      it 'raises InvalidOptionError' do
        expect { parse }.to raise_error(InvalidOptionError, /missing argument/)
      end
    end
  end
end
