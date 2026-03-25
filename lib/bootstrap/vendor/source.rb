require_relative 'source/git_hub_api'
require_relative 'source/git_hub_raw'
require_relative 'source/js_delivr_git_hub'
require_relative 'source/js_delivr_npm'

module Bootstrap
  module Vendor
    module Source
      SOURCES = {
        'jsdelivr_npm'    => JSDelivrNPM,
        'jsdelivr_github' => JSDelivrGitHub,
        'github_raw'      => GitHubRaw,
        'github_api'      => GitHubAPI
      }.freeze

      DEFAULT_ORDER = %w[jsdelivr_npm jsdelivr_github github_raw github_api].freeze

      def self.for name
        klass = SOURCES[name]
        raise Error, "Unknown source: '#{name}'. Valid sources: #{SOURCES.keys.join(', ')}" unless klass

        klass.new
      end

      def self.default_chain
        DEFAULT_ORDER.map { SOURCES[it].new }
      end
    end
  end
end
