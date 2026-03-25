require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

require 'rubocop/rake_task'

RuboCop::RakeTask.new

task default: %i[spec rubocop]

desc 'Update VERSIONS file from GitHub releases'
task :versions do
  require 'http'
  require 'json'

  puts 'Fetching releases from GitHub...'

  versions = []
  page = 1

  loop do
    response = HTTP.get("https://api.github.com/repos/twbs/bootstrap/releases?per_page=100&page=#{page}")
    releases = JSON.parse(response.body.to_s)
    break if releases.empty?

    releases.each do |release|
      tag = release['tag_name'].delete_prefix('v')
      next if release['prerelease']
      next if tag.match?(/alpha|beta|rc/i)

      versions << tag
    end

    page += 1
  end

  versions.sort_by! { Gem::Version.new(it) }

  versions_path = File.expand_path('VERSIONS', __dir__)
  current = File.readlines(versions_path, chomp: true).reject(&:empty?)
  new_versions = versions - current

  if new_versions.empty?
    puts 'VERSIONS is up to date.'
  else
    File.write(versions_path, "#{versions.join("\n")}\n")
    puts "Added #{new_versions.length} new version(s): #{new_versions.join(', ')}"
  end
end
