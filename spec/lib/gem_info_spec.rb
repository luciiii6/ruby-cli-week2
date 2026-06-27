# frozen_string_literal: true

require './lib/gem_info'

RSpec.describe GemInfo do
  subject(:gem) { described_class.new(data) }

  let(:data) do
    { 'name' => 'rails', 'info' => 'Web framework', 'licenses' => ['MIT'] }
  end

  it 'exposes name' do
    expect(gem.name).to eq('rails')
  end

  it 'exposes info' do
    expect(gem.info).to eq('Web framework')
  end

  it 'exposes licenses' do
    expect(gem.licenses).to eq(['MIT'])
  end

  describe '#to_s' do
    it 'joins name and info with a colon' do
      expect(gem.to_s).to eq('rails:Web framework')
    end
  end
end
