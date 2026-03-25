RSpec.describe Bootstrap::Vendor::Source::GitHubAPI do
  subject(:source) { described_class.new }

  describe '#url_for' do
    it 'returns the release dist zip URL' do
      url = source.url_for(version: '5.3.8', subdir: 'css', filename: 'bootstrap.css')

      expect(url).to eq('https://github.com/twbs/bootstrap/releases/download/v5.3.8/bootstrap-5.3.8-dist.zip')
    end
  end

  describe '#name' do
    it 'returns the source name' do
      expect(source.name).to eq('github_api')
    end
  end

  describe '#download_file' do
    let(:tmp_dir) { Dir.mktmpdir }

    after { FileUtils.remove_entry(tmp_dir) }

    it 'downloads the zip and extracts the requested file' do
      tempfile = create_test_zip_file('bootstrap-5.3.8-dist/css/bootstrap.css' => 'body { margin: 0; }')

      allow(Down).to receive(:download).and_return(tempfile)

      destination = File.join(tmp_dir, 'bootstrap.css')

      source.download_file(version: '5.3.8', subdir: 'css', filename: 'bootstrap.css', destination:)

      expect(File.read(destination)).to eq('body { margin: 0; }')
    end

    it 'reuses the cached zip for multiple files' do
      tempfile = create_test_zip_file(
        'bootstrap-5.3.8-dist/css/bootstrap.css'     => 'body {}',
        'bootstrap-5.3.8-dist/css/bootstrap.css.map' => '{}'
      )

      allow(Down).to receive(:download).and_return(tempfile)

      dest_css = File.join(tmp_dir, 'bootstrap.css')
      dest_map = File.join(tmp_dir, 'bootstrap.css.map')

      source.download_file(version: '5.3.8', subdir: 'css', filename: 'bootstrap.css', destination: dest_css)
      source.download_file(version: '5.3.8', subdir: 'css', filename: 'bootstrap.css.map', destination: dest_map)

      expect(Down).to have_received(:download).once
      expect(File.read(dest_css)).to eq('body {}')
      expect(File.read(dest_map)).to eq('{}')
    end
  end

  private

  def create_test_zip_file entries
    require 'tempfile'
    require 'zip'

    tempfile = Tempfile.new(%w[bootstrap .zip])
    tempfile.binmode

    Zip::OutputStream.open(tempfile.path) do |zip|
      entries.each do |path, content|
        zip.put_next_entry(path)
        zip.write(content)
      end
    end

    tempfile
  end
end
