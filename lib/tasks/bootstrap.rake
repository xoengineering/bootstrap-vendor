require 'bootstrap/vendor'

def bootstrap_sources config
  if config.source
    [Bootstrap::Vendor::Source.for(config.source)]
  else
    Bootstrap::Vendor::Source.default_chain
  end
end

namespace :bootstrap do
  desc 'Print the current Bootstrap version from .bootstrap-version'
  task :version, [:path] do |_t, args|
    path = args[:path] || '.'
    version_file = Bootstrap::Vendor::VersionFile.new(path:)

    if version_file.exists?
      puts version_file.read
    else
      puts 'No .bootstrap-version file found. Create one with:'
      puts 'rake bootstrap:init'
    end
  end

  desc 'Print the latest Bootstrap version (optionally within a constraint)'
  task :latest, [:version] do |_t, args|
    constraint = args[:version]
    latest = Bootstrap::Vendor::Registry.latest(constraint:)
    puts latest
  end

  desc 'Compare current version to latest upstream version'
  task :status, [:version, :path] do |_t, args|
    path = args[:path] || '.'
    version_file = Bootstrap::Vendor::VersionFile.new(path:)

    unless version_file.exists?
      puts 'No .bootstrap-version file found. Create one with:'
      puts 'rake bootstrap:init'
      next
    end

    current = version_file.read
    constraint = args[:version]
    latest = Bootstrap::Vendor::Registry.latest(constraint:)

    if current == latest
      puts "Current version #{current} is up to date"
    else
      constraint_label = constraint ? " #{constraint}.x.y" : ''
      puts "Current version #{current} is behind latest#{constraint_label} version #{latest}"
    end
  end

  desc 'Create a .bootstrap-version file'
  task :init, [:version, :path, :overwrite] do |_t, args|
    version = args[:version]
    path = args[:path] || '.'
    overwrite = args[:overwrite] == 'overwrite' || version == 'overwrite'

    # Handle bootstrap:init['overwrite'] (version arg is actually 'overwrite')
    version = nil if version == 'overwrite'

    resolved = Bootstrap::Vendor::Registry.latest(constraint: version)
    version_file = Bootstrap::Vendor::VersionFile.new(path:)

    if version_file.exists? && !overwrite
      puts 'A .bootstrap-version file already exists.'
      puts "Version: #{version_file.read}"
      puts "Use 'overwrite' to replace it."
      puts "rake bootstrap:init['overwrite']"
      next
    end

    version_file.write(version: resolved)
    puts 'A .bootstrap-version file was created.'
    puts "Version: #{resolved}"
  end

  desc 'Download Bootstrap CSS and JS files'
  task :install, [:version, :path] do |_t, args|
    path = args[:path] || '.'
    version_file = Bootstrap::Vendor::VersionFile.new(path:)

    if version_file.exists?
      puts 'Bootstrap is already installed.'
      puts "Version: #{version_file.read}"
      puts "Use 'rake bootstrap:update' to update."
      next
    end

    constraint = args[:version]
    resolved = Bootstrap::Vendor::Registry.latest(constraint:)
    config = Bootstrap::Vendor::Config.new
    sources = bootstrap_sources(config)
    file_list = Bootstrap::Vendor::FileList.new(config:, version: resolved, root: path, sources:)

    file_list.download

    version_file.write(version: resolved)

    puts 'CSS:'
    file_list.expected.select { it[:destination].include?('stylesheets') }.each do |entry|
      puts "  #{entry[:destination]}"
    end
    puts 'JS:'
    file_list.expected.select { it[:destination].include?('javascript') }.each do |entry|
      puts "  #{entry[:destination]}"
    end
  end

  desc 'Update Bootstrap CSS and JS files to latest version'
  task :update, [:version, :path] do |_t, args|
    path = args[:path] || '.'
    version_file = Bootstrap::Vendor::VersionFile.new(path:)
    current = version_file.read || '0.0.0'

    constraint = args[:version]
    resolved = Bootstrap::Vendor::Registry.latest(constraint:)
    config = Bootstrap::Vendor::Config.new
    sources = bootstrap_sources(config)
    file_list = Bootstrap::Vendor::FileList.new(config:, version: resolved, root: path, sources:)

    file_list.download

    version_file.write(version: resolved)

    puts "Bootstrap updated from #{current} to #{resolved}"
    puts ''
    puts 'CSS:'
    file_list.expected.select { it[:destination].include?('stylesheets') }.each do |entry|
      puts "  #{entry[:destination]}"
    end
    puts 'JS:'
    file_list.expected.select { it[:destination].include?('javascript') }.each do |entry|
      puts "  #{entry[:destination]}"
    end
  end

  desc 'Vendor Bootstrap: init, fetch latest, update'
  task :vendor, [:path] do |_t, args|
    path = args[:path] || '.'
    version_file = Bootstrap::Vendor::VersionFile.new(path:)

    resolved = Bootstrap::Vendor::Registry.latest
    config = Bootstrap::Vendor::Config.new
    sources = bootstrap_sources(config)
    file_list = Bootstrap::Vendor::FileList.new(config:, version: resolved, root: path, sources:)

    file_list.download

    version_file.write(version: resolved)

    puts "Bootstrap #{resolved} vendored."
    puts ''
    puts 'CSS:'
    file_list.expected.select { it[:destination].include?('stylesheets') }.each do |entry|
      puts "  #{entry[:destination]}"
    end
    puts 'JS:'
    file_list.expected.select { it[:destination].include?('javascript') }.each do |entry|
      puts "  #{entry[:destination]}"
    end
  end

  desc 'Remove vendored Bootstrap files'
  task :uninstall, [:path] do |_t, args|
    path = args[:path] || '.'
    version_file = Bootstrap::Vendor::VersionFile.new(path:)

    unless version_file.exists?
      puts 'No .bootstrap-version file found. Nothing to uninstall.'
      next
    end

    current = version_file.read
    config = Bootstrap::Vendor::Config.new
    file_list = Bootstrap::Vendor::FileList.new(config:, version: current, root: path)

    file_list.installed.each do |dest|
      File.delete(dest)
      puts "Deleted #{dest}"
    end

    version_file.delete
    puts 'Deleted .bootstrap-version'
    puts "Bootstrap #{current} uninstalled."
  end
end
