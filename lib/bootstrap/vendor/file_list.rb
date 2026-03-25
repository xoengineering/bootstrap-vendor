module Bootstrap
  module Vendor
    class FileList
      CDN_BASE = 'https://cdn.jsdelivr.net/npm/bootstrap@'.freeze

      def initialize config:, version:, root: '.'
        @config  = config
        @version = version
        @root    = root
      end

      def expected
        css_entries + js_entries
      end

      def installed
        expected.map { it[:destination] }.select { File.exist?(it) }
      end

      private

      def css_entries
        filenames = []
        filenames.concat(css_filenames_for(rtl: false)) if @config.css_ltr?
        filenames.concat(css_filenames_for(rtl: true)) if @config.css_rtl?
        filenames.map { build_entry(filename: it, subdir: 'css', local_path: @config.css_path) }
      end

      def css_filenames_for rtl:
        base = rtl ? 'bootstrap.rtl' : 'bootstrap'
        base = "#{base}.min" if @config.css_min?
        names = ["#{base}.css"]
        names << "#{base}.css.map" if @config.css_map?
        names
      end

      def js_entries
        js_filenames.map { build_entry(filename: it, subdir: 'js', local_path: @config.js_path) }
      end

      def js_filenames
        base = @config.js_bundle? ? 'bootstrap.bundle' : 'bootstrap'
        base = "#{base}.min" if @config.js_min?
        names = ["#{base}.js"]
        names << "#{base}.js.map" if @config.js_map?
        names
      end

      def build_entry filename:, subdir:, local_path:
        {
          filename:,
          url:         "#{CDN_BASE}#{@version}/dist/#{subdir}/#{filename}",
          destination: File.join(@root, local_path, filename)
        }
      end
    end
  end
end
