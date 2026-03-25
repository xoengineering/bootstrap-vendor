require 'down'
require 'fileutils'
require 'tmpdir'

RSpec.describe Bootstrap::Vendor::FileList, '#download' do
  subject(:file_list) { described_class.new(config:, version:, root:) }

  let(:config) { Bootstrap::Vendor::Config.new }
  let(:version) { '5.3.8' }
  let(:root) { Dir.mktmpdir }

  after { FileUtils.remove_entry(root) }

  it 'downloads each expected file using Down' do
    file_list.expected.each do |entry|
      allow(Down).to receive(:download).with(entry[:url], destination: entry[:destination])
    end
    allow(FileUtils).to receive(:mkdir_p)

    file_list.download

    file_list.expected.each do |entry|
      expect(Down).to have_received(:download).with(entry[:url], destination: entry[:destination])
    end
  end

  it 'creates destination directories before downloading' do
    allow(Down).to receive(:download)

    file_list.download

    expect(File.directory?(File.join(root, 'vendor/stylesheets'))).to be true
    expect(File.directory?(File.join(root, 'vendor/javascript'))).to be true
  end
end
