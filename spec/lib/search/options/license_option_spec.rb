# frozen_string_literal: true

require './lib/search/options/license_option'
require './lib/gem_info'

RSpec.describe LicenseOption do
  subject(:apply) { described_class.new(license).apply(gems) }

  let(:license) { 'MIT' }
  let(:gems) do
    [
      GemInfo.new({ 'name' => 'rails',   'info' => 'web', 'licenses' => ['MIT'] }),
      GemInfo.new({ 'name' => 'sinatra', 'info' => 'micro', 'licenses' => ['BSD'] }),
      GemInfo.new({ 'name' => 'rspec',   'info' => 'test', 'licenses' => ['MIT', 'Apache-2.0'] })
    ]
  end

  describe '#apply' do
    it 'keeps only gems whose licenses include the requested license' do
      expect(apply.map(&:name)).to contain_exactly('rails', 'rspec')
    end

    context 'when no gems match' do
      let(:license) { 'GPL-3.0' }

      it 'returns an empty array' do
        expect(apply).to be_empty
      end
    end
  end
end
