require_relative 'vendor/config'
require_relative 'vendor/file_list'
require_relative 'vendor/registry'
require_relative 'vendor/source'
require_relative 'vendor/version'
require_relative 'vendor/version_file'

module Bootstrap
  module Vendor
    class Error < StandardError; end
  end
end

require_relative 'vendor/railtie' if defined?(Rails::Railtie)
