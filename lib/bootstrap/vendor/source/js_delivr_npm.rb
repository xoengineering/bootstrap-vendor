module Bootstrap
  module Vendor
    module Source
      class JSDelivrNPM
        BASE_URL = 'https://cdn.jsdelivr.net/npm/bootstrap@'.freeze

        def name = 'jsdelivr_npm'

        def url_for version:, subdir:, filename:
          [BASE_URL, version, '/dist/', subdir, '/', filename].join
        end

        def download_file version:, subdir:, filename:, destination:
          require 'down'

          Down.download(url_for(version:, subdir:, filename:), destination:)
        end
      end
    end
  end
end
