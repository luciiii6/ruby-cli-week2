# frozen_string_literal: true

require './lib/search/options/most_downloads_first_option'
require './lib/gem_info'

RSpec.describe MostDownloadsFirstOption do
  subject(:apply) { described_class.new.apply(gems) }

  let(:gems) do
    [
      GemInfo.new({ 'name' => 'low',    'downloads' => 100 }),
      GemInfo.new({ 'name' => 'high',   'downloads' => 10_000 }),
      GemInfo.new({ 'name' => 'medium', 'downloads' => 1_000 })
    ]
  end

  describe '#apply' do
    it 'orders gems from most to least downloads' do
      expect(apply.map(&:name)).to eq(%w[high medium low])
    end
  end
end
