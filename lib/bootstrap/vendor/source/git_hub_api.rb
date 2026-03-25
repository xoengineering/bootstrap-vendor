require 'zip'

module Bootstrap
  module Vendor
    module Source
      class GitHubAPI
        BASE_URL = 'https://github.com/twbs/bootstrap/releases/download/v'.freeze

        def name = 'github_api'

        def url_for version:, subdir: nil, filename: nil # rubocop:disable Lint/UnusedMethodArgument
          "#{BASE_URL}#{version}/bootstrap-#{version}-dist.zip"
        end

        def download_file version:, subdir:, filename:, destination:
          zip = cached_zip(version:)
          entry_path = "bootstrap-#{version}-dist/#{subdir}/#{filename}"
          entry = zip.find_entry(entry_path)
          raise Down::NotFound, "#{entry_path} not found in zip" unless entry

          File.binwrite(destination, entry.get_input_stream.read)
        end

        private

        def cached_zip version:
          @cached_zips ||= {}
          @cached_zips[version] ||= download_zip(version:)
        end

        def download_zip version:
          require 'down'
          require 'tmpdir'

          tempfile = Down.download(url_for(version:))
          Zip::File.open(tempfile.path)
        end
      end
    end
  end
end
