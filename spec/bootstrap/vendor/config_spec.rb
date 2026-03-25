RSpec.describe Bootstrap::Vendor::Config do
  subject(:config) { described_class.new }

  describe 'CSS defaults' do
    it 'enables LTR by default' do
      expect(config.css_ltr?).to be true
    end

    it 'disables RTL by default' do
      expect(config.css_rtl?).to be false
    end

    it 'enables source maps by default' do
      expect(config.css_map?).to be true
    end

    it 'disables minification by default' do
      expect(config.css_min?).to be false
    end
  end

  describe 'JS defaults' do
    it 'enables bundle by default' do
      expect(config.js_bundle?).to be true
    end

    it 'enables source maps by default' do
      expect(config.js_map?).to be true
    end

    it 'disables minification by default' do
      expect(config.js_min?).to be false
    end
  end

  describe 'path defaults' do
    it 'defaults css_path to vendor/stylesheets' do
      expect(config.css_path).to eq('vendor/stylesheets')
    end

    it 'defaults js_path to vendor/javascript' do
      expect(config.js_path).to eq('vendor/javascript')
    end
  end

  describe 'ENV overrides' do
    around do |example|
      original_env = ENV.to_h
      example.run
    ensure
      ENV.replace(original_env)
    end

    it 'reads BOOTSTRAP_VENDOR_CSS_LTR' do
      ENV['BOOTSTRAP_VENDOR_CSS_LTR'] = 'false'
      ENV['BOOTSTRAP_VENDOR_CSS_RTL'] = 'true'

      expect(described_class.new.css_ltr?).to be false
    end

    it 'reads BOOTSTRAP_VENDOR_CSS_RTL' do
      ENV['BOOTSTRAP_VENDOR_CSS_RTL'] = 'true'

      expect(described_class.new.css_rtl?).to be true
    end

    it 'reads BOOTSTRAP_VENDOR_CSS_MAP' do
      ENV['BOOTSTRAP_VENDOR_CSS_MAP'] = 'false'

      expect(described_class.new.css_map?).to be false
    end

    it 'reads BOOTSTRAP_VENDOR_CSS_MIN' do
      ENV['BOOTSTRAP_VENDOR_CSS_MIN'] = 'true'

      expect(described_class.new.css_min?).to be true
    end

    it 'reads BOOTSTRAP_VENDOR_JS_BUNDLE' do
      ENV['BOOTSTRAP_VENDOR_JS_BUNDLE'] = 'false'

      expect(described_class.new.js_bundle?).to be false
    end

    it 'reads BOOTSTRAP_VENDOR_JS_MAP' do
      ENV['BOOTSTRAP_VENDOR_JS_MAP'] = 'false'

      expect(described_class.new.js_map?).to be false
    end

    it 'reads BOOTSTRAP_VENDOR_JS_MIN' do
      ENV['BOOTSTRAP_VENDOR_JS_MIN'] = 'true'

      expect(described_class.new.js_min?).to be true
    end
  end

  describe 'validation' do
    around do |example|
      original_env = ENV.to_h
      example.run
    ensure
      ENV.replace(original_env)
    end

    it 'raises when both CSS_LTR and CSS_RTL are false' do
      ENV['BOOTSTRAP_VENDOR_CSS_LTR'] = 'false'
      ENV['BOOTSTRAP_VENDOR_CSS_RTL'] = 'false'

      expect { described_class.new }.to raise_error(Bootstrap::Vendor::Error, /at least one of LTR or RTL/i)
    end
  end
end
