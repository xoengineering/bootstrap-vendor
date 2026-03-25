RSpec.describe Bootstrap::Vendor::FileList, '#download' do
  subject(:file_list) { described_class.new(config:, version:, root:, sources: [source]) }

  let(:config) { Bootstrap::Vendor::Config.new }
  let(:version) { '5.3.8' }
  let(:root) { Dir.mktmpdir }
  let(:source) { instance_double(Bootstrap::Vendor::Source::JSDelivrNPM) }

  after { FileUtils.remove_entry(root) }

  it 'downloads each expected file via the source' do
    allow(source).to receive(:download_file)

    file_list.download

    file_list.expected.each do |entry|
      expect(source).to have_received(:download_file).with(
        version:     '5.3.8',
        subdir:      entry[:subdir],
        filename:    entry[:filename],
        destination: entry[:destination]
      )
    end
  end

  it 'creates destination directories before downloading' do
    allow(source).to receive(:download_file)

    file_list.download

    expect(File.directory?(File.join(root, 'vendor/stylesheets'))).to be true
    expect(File.directory?(File.join(root, 'vendor/javascript'))).to be true
  end

  it 'falls back to the next source on failure' do
    failing_source = instance_double(Bootstrap::Vendor::Source::JSDelivrNPM)
    allow(failing_source).to receive(:download_file).and_raise(Down::ConnectionError, 'connection refused')
    allow(source).to receive(:download_file)

    file_list_with_fallback = described_class.new(
      config:, version:, root:, sources: [failing_source, source]
    )

    file_list_with_fallback.download

    expect(source).to have_received(:download_file).exactly(4).times
  end

  it 'raises the last error when all sources fail' do
    failing_source = instance_double(Bootstrap::Vendor::Source::JSDelivrNPM)
    allow(failing_source).to receive(:download_file).and_raise(Down::ConnectionError, 'connection refused')

    file_list_all_fail = described_class.new(
      config:, version:, root:, sources: [failing_source]
    )

    expect { file_list_all_fail.download }.to raise_error(Down::ConnectionError, 'connection refused')
  end
end
