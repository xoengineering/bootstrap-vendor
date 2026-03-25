module Bootstrap
  module Vendor
    class Config
      attr_reader :source

      def initialize
        @css_ltr   = env_bool 'BOOTSTRAP_VENDOR_CSS_LTR', default: true
        @css_map   = env_bool 'BOOTSTRAP_VENDOR_CSS_MAP', default: true
        @css_min   = env_bool 'BOOTSTRAP_VENDOR_CSS_MIN', default: false
        @css_rtl   = env_bool 'BOOTSTRAP_VENDOR_CSS_RTL', default: false
        @js_bundle = env_bool 'BOOTSTRAP_VENDOR_JS_BUNDLE', default: true
        @js_map    = env_bool 'BOOTSTRAP_VENDOR_JS_MAP', default: true
        @js_min    = env_bool 'BOOTSTRAP_VENDOR_JS_MIN', default: false
        @source    = ENV.fetch 'BOOTSTRAP_VENDOR_SOURCE', nil

        validate!
      end

      def css_map? = @css_map
      def css_min? = @css_min
      def css_path = 'vendor/stylesheets'
      def js_map?  = @js_map
      def js_min?  = @js_min
      def js_path  = 'vendor/javascript'

      def css_ltr?   = @css_ltr
      def css_rtl?   = @css_rtl
      def js_bundle? = @js_bundle

      private

      def env_bool key, default:
        value = ENV.fetch key, nil
        return default if value.nil?

        value.downcase == 'true'
      end

      def validate!
        return if css_ltr? || css_rtl?

        raise Error, 'At least one of LTR or RTL must be true'
      end
    end
  end
end
