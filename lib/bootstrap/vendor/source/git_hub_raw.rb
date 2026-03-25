module Bootstrap
  module Vendor
    module Source
      class GitHubRaw
        NAME = 'github_raw'.freeze
        BASE_URL = 'https://raw.githubusercontent.com/twbs/bootstrap/refs/tags/v'.freeze

        def name = NAME

        def url_for version:, subdir:, filename:
          [BASE_URL, version, '/dist/', subdir, '/', filename].join
        end

        def download_file version:, subdir:, filename:, destination:
          require 'down'

          Down.download url_for(version:, subdir:, filename:), destination:
        end
      end
    end
  end
end
