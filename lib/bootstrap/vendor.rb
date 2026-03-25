require_relative 'vendor/config'
require_relative 'vendor/registry'
require_relative 'vendor/version'
require_relative 'vendor/version_file'

module Bootstrap
  module Vendor
    class Error < StandardError; end
  end
end
