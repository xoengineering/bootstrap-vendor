RSpec.describe Bootstrap::Vendor::Source do
  describe '.new' do
    it 'returns a source instance for a valid name' do
      source = described_class.build('jsdelivr_npm')

      expect(source).to be_a(Bootstrap::Vendor::Source::JSDelivrNPM)
    end

    it 'accepts symbol names' do
      source = described_class.build(:github_raw)

      expect(source).to be_a(Bootstrap::Vendor::Source::GitHubRaw)
    end

    it 'raises an error for an unknown source' do
      expect { described_class.build('nonexistent') }.to raise_error(
        Bootstrap::Vendor::Error, /Unknown source: 'nonexistent'/
      )
    end
  end

  describe '.default_chain' do
    it 'returns all four sources in order' do
      chain = described_class.default_chain

      expect(chain.map(&:name)).to eq(%w[jsdelivr_npm jsdelivr_github github_raw github_api])
    end
  end
end
