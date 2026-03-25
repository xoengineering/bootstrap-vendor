module Bootstrap
  module Vendor
    class VersionFile
      FILENAME = '.bootstrap-version'.freeze

      def initialize path:
        @path = resolve_path(path)
      end

      def exists?
        File.exist?(@path)
      end

      def read
        return nil unless exists?

        File.read(@path).strip
      end

      def write version:
        File.write(@path, "#{version}\n")
      end

      private

      def resolve_path path
        if File.directory?(path)
          File.join(path, FILENAME)
        else
          path
        end
      end
    end
  end
end
