# frozen_string_literal: true

require './lib/search/search_options_parser'
require './lib/search/options/license_option'

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
  end
end
