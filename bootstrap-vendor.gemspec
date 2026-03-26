require_relative 'lib/bootstrap/vendor/version'

Gem::Specification.new do |spec|
  spec.name = 'bootstrap-vendor'
  spec.version = Bootstrap::Vendor::VERSION
  spec.authors = ['Shane Becker']
  spec.email = ['veganstraightedge@gmail.com']

  spec.summary     = 'Rake tasks to vendor Bootstrap CSS and JS into your Rails app'
  spec.description = 'Manage vendored Bootstrap files with rake tasks: check versions, download, update, and uninstall.'
  spec.homepage    = 'https://github.com/xoengineering/bootstrap-vendor'
  spec.license     = 'MIT'

  spec.required_ruby_version = '>= 4.0'

  spec.metadata['allowed_push_host']     = 'https://rubygems.org'
  spec.metadata['homepage_uri']          = spec.homepage
  spec.metadata['source_code_uri']       = 'https://github.com/xoengineering/bootstrap-vendor'
  spec.metadata['changelog_uri']         = 'https://github.com/xoengineering/bootstrap-vendor/blob/main/CHANGELOG.md'
  spec.metadata['rubygems_mfa_required'] = 'true'

  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ Gemfile .gitignore .rspec spec/ .github/ .rubocop.yml])
    end
  end
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'down', '~> 5.5'
  spec.add_dependency 'http', '~> 6.0'
  spec.add_dependency 'rubyzip', '~> 3.2'
end
