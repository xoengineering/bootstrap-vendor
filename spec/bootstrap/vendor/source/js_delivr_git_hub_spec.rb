RSpec.describe Bootstrap::Vendor::Source::JSDelivrGitHub do
  subject(:source) { described_class.new }

  describe '#url_for' do
    it 'builds a jsdelivr GitHub URL with v prefix' do
      url = source.url_for(version: '5.3.8', subdir: 'css', filename: 'bootstrap.css')

      expect(url).to eq('https://cdn.jsdelivr.net/gh/twbs/bootstrap@v5.3.8/dist/css/bootstrap.css')
    end
  end

  describe '#name' do
    it 'returns the source name' do
      expect(source.name).to eq('jsdelivr_github')
    end
  end

  describe '#download_file' do
    it 'downloads the file using Down' do
      allow(Down).to receive(:download)

      source.download_file(version: '5.3.8', subdir: 'css', filename: 'bootstrap.css', destination: '/tmp/bootstrap.css')

      expect(Down).to have_received(:download).with(
        'https://cdn.jsdelivr.net/gh/twbs/bootstrap@v5.3.8/dist/css/bootstrap.css',
        destination: '/tmp/bootstrap.css'
      )
    end
  end
end
