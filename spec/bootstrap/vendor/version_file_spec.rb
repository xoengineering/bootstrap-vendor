require 'fileutils'
require 'tmpdir'

RSpec.describe Bootstrap::Vendor::VersionFile do
  subject(:version_file) { described_class.new(path:) }

  let(:tmp_dir) { Dir.mktmpdir }
  let(:path) { tmp_dir }

  after { FileUtils.remove_entry(tmp_dir) }

  describe '#exists?' do
    context 'when .bootstrap-version file does not exist' do
      it 'returns false' do
        expect(version_file.exists?).to be false
      end
    end

    context 'when .bootstrap-version file exists' do
      before { File.write(File.join(tmp_dir, '.bootstrap-version'), "5.3.8\n") }

      it 'returns true' do
        expect(version_file.exists?).to be true
      end
    end
  end

  describe '#read' do
    context 'when .bootstrap-version file does not exist' do
      it 'returns nil' do
        expect(version_file.read).to be_nil
      end
    end

    context 'when .bootstrap-version file exists' do
      before { File.write(File.join(tmp_dir, '.bootstrap-version'), "5.3.8\n") }

      it 'returns the version string stripped of whitespace' do
        expect(version_file.read).to eq('5.3.8')
      end
    end
  end

  describe '#write' do
    it 'creates the .bootstrap-version file with the given version' do
      version_file.write(version: '5.3.8')

      expect(File.read(File.join(tmp_dir, '.bootstrap-version'))).to eq("5.3.8\n")
    end

    it 'overwrites an existing .bootstrap-version file' do
      version_file.write(version: '5.2.3')
      version_file.write(version: '5.3.8')

      expect(File.read(File.join(tmp_dir, '.bootstrap-version'))).to eq("5.3.8\n")
    end
  end

  describe 'path handling' do
    context 'when path is a directory' do
      it 'appends .bootstrap-version' do
        version_file.write(version: '5.3.8')

        expect(File.exist?(File.join(tmp_dir, '.bootstrap-version'))).to be true
      end
    end

    context 'when path is a file path' do
      let(:path) { File.join(tmp_dir, '.bootstrap-version') }

      it 'uses the path directly' do
        version_file.write(version: '5.3.8')

        expect(File.exist?(path)).to be true
      end
    end

    context 'when path is a custom file name' do
      let(:path) { File.join(tmp_dir, 'my-bootstrap-version') }

      it 'uses the custom file path' do
        version_file.write(version: '4.6.2')

        expect(File.read(path)).to eq("4.6.2\n")
      end
    end
  end
end
