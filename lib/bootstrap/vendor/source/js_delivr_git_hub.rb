module Bootstrap
  module Vendor
    module Source
      class JSDelivrGitHub
        NAME = 'jsdelivr_github'.freeze
        BASE_URL = 'https://cdn.jsdelivr.net/gh/twbs/bootstrap@v'.freeze

        def name = NAME

        def url_for version:, subdir:, filename:
          [BASE_URL, version, '/dist/', subdir, '/', filename].join
        end

        def download_file version:, subdir:, filename:, destination:
          Down.download url_for(version:, subdir:, filename:), destination:
        end
      end
    end
  end
end
