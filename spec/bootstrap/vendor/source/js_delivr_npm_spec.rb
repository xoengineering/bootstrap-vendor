RSpec.describe Bootstrap::Vendor::Source::JSDelivrNPM do
  subject(:source) { described_class.new }

  describe '#url_for' do
    it 'builds a jsdelivr npm URL for CSS' do
      url = source.url_for(version: '5.3.8', subdir: 'css', filename: 'bootstrap.css')

      expect(url).to eq('https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.css')
    end

    it 'builds a jsdelivr npm URL for JS' do
      url = source.url_for(version: '5.3.8', subdir: 'js', filename: 'bootstrap.bundle.js')

      expect(url).to eq('https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.js')
    end
  end

  describe '#name' do
    it 'returns the source name' do
      expect(source.name).to eq('jsdelivr_npm')
    end
  end
end
