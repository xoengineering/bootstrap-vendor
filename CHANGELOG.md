# Changelog

## [Unreleased]

## [0.1.0] - 2026-03-26

- Initial release

- Fix install to check for existing files instead of just .bootstrap-version
- Fix uninstall to clean up files even without .bootstrap-version
- Add non-Rails usage instructions to README
- Add zsh escaping notes to README
- Remove simplecov dependency
- Add download source fallback chain (JSDelivrNPM, JSDelivrGitHub, GitHubRaw, GitHubAPI)
- Support BOOTSTRAP_VENDOR_SOURCE ENV var to pin a specific source
- Add `rake versions` maintainer task to update VERSIONS from GitHub
- Extract version list to flat VERSIONS file, read by Registry at runtime
- Add rake tasks: version, latest, status, init, install, update, vendor, uninstall
- Add Railtie to load rake tasks in Rails apps
- Add VersionFile#delete and #path accessor
- Add FileList#download to fetch files from jsdelivr CDN
- Add FileList to compute expected/installed files with CDN URLs
- Add Config for ENV-based settings with opinionated defaults
- Add VersionFile to read/write .bootstrap-version files
- Add Registry with hardcoded list of all stable Bootstrap versions and constraint matching
