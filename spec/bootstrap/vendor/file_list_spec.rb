RSpec.describe Bootstrap::Vendor::FileList do
  subject(:file_list) { described_class.new(config:, version:, root:) }

  let(:config) { Bootstrap::Vendor::Config.new }
  let(:version) { '5.3.8' }
  let(:root) { Dir.mktmpdir }

  after { FileUtils.remove_entry(root) }

  describe '#expected' do
    context 'with default config' do
      it 'returns default CSS and JS files' do
        expected = file_list.expected

        expect(expected.map { it[:filename] }).to eq(
          %w[
            bootstrap.css
            bootstrap.css.map
            bootstrap.bundle.js
            bootstrap.bundle.js.map
          ]
        )
      end

      it 'includes subdir for each entry' do
        expected = file_list.expected

        css_entries = expected.select { it[:subdir] == 'css' }
        js_entries = expected.select { it[:subdir] == 'js' }

        expect(css_entries.length).to eq(2)
        expect(js_entries.length).to eq(2)
      end

      it 'includes destination paths under root' do
        expected = file_list.expected

        expect(expected.first[:destination]).to eq(
          File.join(root, 'vendor/stylesheets/bootstrap.css')
        )
      end
    end

    context 'with RTL enabled and LTR enabled' do
      around do |example|
        original_env = ENV.to_h
        ENV['BOOTSTRAP_VENDOR_CSS_RTL'] = 'true'
        example.run
      ensure
        ENV.replace(original_env)
      end

      let(:config) { Bootstrap::Vendor::Config.new }

      it 'includes both LTR and RTL CSS files' do
        filenames = file_list.expected.map { it[:filename] }

        expect(filenames).to include('bootstrap.css', 'bootstrap.rtl.css')
      end
    end

    context 'with minification enabled' do
      around do |example|
        original_env = ENV.to_h
        ENV['BOOTSTRAP_VENDOR_CSS_MIN'] = 'true'
        ENV['BOOTSTRAP_VENDOR_JS_MIN'] = 'true'
        example.run
      ensure
        ENV.replace(original_env)
      end

      let(:config) { Bootstrap::Vendor::Config.new }

      it 'uses minified filenames' do
        filenames = file_list.expected.map { it[:filename] }

        expect(filenames).to include('bootstrap.min.css', 'bootstrap.bundle.min.js')
        expect(filenames).not_to include('bootstrap.css', 'bootstrap.bundle.js')
      end
    end

    context 'with maps disabled' do
      around do |example|
        original_env = ENV.to_h
        ENV['BOOTSTRAP_VENDOR_CSS_MAP'] = 'false'
        ENV['BOOTSTRAP_VENDOR_JS_MAP'] = 'false'
        example.run
      ensure
        ENV.replace(original_env)
      end

      let(:config) { Bootstrap::Vendor::Config.new }

      it 'excludes map files' do
        filenames = file_list.expected.map { it[:filename] }

        expect(filenames).to eq(%w[bootstrap.css bootstrap.bundle.js])
      end
    end

    context 'with bundle disabled' do
      around do |example|
        original_env = ENV.to_h
        ENV['BOOTSTRAP_VENDOR_JS_BUNDLE'] = 'false'
        example.run
      ensure
        ENV.replace(original_env)
      end

      let(:config) { Bootstrap::Vendor::Config.new }

      it 'uses plain bootstrap.js instead of bundle' do
        filenames = file_list.expected.map { it[:filename] }

        expect(filenames).to include('bootstrap.js', 'bootstrap.js.map')
        expect(filenames).not_to include('bootstrap.bundle.js')
      end
    end
  end

  describe '#installed' do
    it 'returns empty array when no files exist' do
      expect(file_list.installed).to eq([])
    end

    it 'returns paths of expected files that exist on disk' do
      css_dir = File.join(root, 'vendor/stylesheets')
      FileUtils.mkdir_p(css_dir)
      File.write(File.join(css_dir, 'bootstrap.css'), 'body {}')

      installed = file_list.installed

      expect(installed).to eq([File.join(css_dir, 'bootstrap.css')])
    end
  end
end
