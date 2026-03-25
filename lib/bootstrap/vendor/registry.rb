module Bootstrap
  module Vendor
    module Registry
      VERSIONS_PATH = File.expand_path('../../../VERSIONS.txt', __dir__).freeze

      def self.all
        @all ||= File.readlines(VERSIONS_PATH, chomp: true).reject(&:empty?)
      end

      def self.latest constraint: nil
        return all.last if constraint.nil?

        requirement = build_requirement(constraint.to_s)
        matches     = all.select { requirement.satisfied_by? Gem::Version.new it }

        raise Error, "No versions matching '#{constraint}'" if matches.empty?

        matches.last
      end

      def self.build_requirement constraint
        segments = Gem::Version.new(constraint).segments

        case segments.length
        when 1    then Gem::Requirement.new("~> #{segments[0]}.0")
        when 2, 3 then Gem::Requirement.new("~> #{segments[0]}.#{segments[1]}.0")
        end
      end

      private_class_method :build_requirement
    end
  end
end
