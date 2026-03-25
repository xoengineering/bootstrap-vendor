RSpec.describe Bootstrap::Vendor::Registry do
  describe '.all' do
    it 'returns an array of version strings' do
      versions = described_class.all

      expect(versions).to be_an(Array)
      expect(versions).to all(be_a(String))
    end

    it 'includes known versions' do
      versions = described_class.all

      expect(versions).to include('5.3.8', '4.6.2', '3.4.1', '2.3.2', '1.0.0')
    end

    it 'excludes pre-release versions' do
      versions = described_class.all

      expect(versions).not_to include('5.3.0-alpha1')
      expect(versions).not_to include('5.0.0-beta1')
      expect(versions).not_to include('4.0.0-beta')
      expect(versions).not_to include('3.0.0-rc1')
    end

    it 'returns versions sorted ascending' do
      versions = described_class.all

      expect(versions).to eq(versions.sort_by { Gem::Version.new it })
    end
  end

  describe '.latest' do
    context 'without a constraint' do
      it 'returns the latest version overall' do
        expect(described_class.latest).to eq('5.3.8')
      end
    end

    context 'with a major constraint' do
      it 'returns the latest version in that major' do
        expect(described_class.latest(constraint: '5')).to eq('5.3.8')
        expect(described_class.latest(constraint: '4')).to eq('4.6.2')
        expect(described_class.latest(constraint: '3')).to eq('3.4.1')
      end
    end

    context 'with a major.minor constraint' do
      it 'returns the latest version in that major.minor' do
        expect(described_class.latest(constraint: '5.3')).to eq('5.3.8')
        expect(described_class.latest(constraint: '5.2')).to eq('5.2.3')
        expect(described_class.latest(constraint: '4.5')).to eq('4.5.3')
        expect(described_class.latest(constraint: '3.3')).to eq('3.3.7')
      end
    end

    context 'with a full version constraint' do
      it 'returns the latest patch in that major.minor' do
        expect(described_class.latest(constraint: '5.3.5')).to eq('5.3.8')
        expect(described_class.latest(constraint: '4.6.0')).to eq('4.6.2')
      end
    end

    context 'with an invalid constraint' do
      it 'raises an error for an unknown major version' do
        expect { described_class.latest(constraint: '99') }.to raise_error(Bootstrap::Vendor::Error, /no versions/i)
      end

      it 'raises an error for an unknown minor version' do
        expect { described_class.latest(constraint: '5.99') }.to raise_error(Bootstrap::Vendor::Error, /no versions/i)
      end
    end
  end
end
