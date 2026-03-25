module Bootstrap
  module Vendor
    module Registry
      VERSIONS_PATH = File.expand_path('../../../VERSIONS', __dir__).freeze

      def self.all
        @all ||= File.readlines(VERSIONS_PATH, chomp: true).reject(&:empty?)
      end

      def self.latest constraint: nil
        return all.last if constraint.nil?

        prefix = constraint.to_s
        parts = prefix.split('.')
        prefix = parts[0..1].join('.') if parts.length == 3

        matches = all.select { it.start_with?("#{prefix}.") || it == prefix }
        raise Error, "No versions matching '#{constraint}'" if matches.empty?

        matches.last
      end

      def self.reset!
        @all = nil
      end
    end
  end
end
