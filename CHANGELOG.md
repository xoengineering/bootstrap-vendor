# Changelog

## [Unreleased]

## [0.1.0] - 2026-03-26

- Add rake tasks: vendor, version, latest, status, init, install, update, uninstall
- Add Railtie to load rake tasks in Rails apps
- Add Registry with all stable Bootstrap versions and constraint matching via Gem::Requirement
- Add VersionFile to read/write .bootstrap-version files
- Add Config for ENV-based settings with opinionated defaults
- Add FileList to compute expected/installed files and download with source fallback
- Add download source fallback chain (JSDelivrNPM, JSDelivrGitHub, GitHubRaw, GitHubAPI)
- Support BOOTSTRAP_VENDOR_SOURCE ENV var to pin a specific download source
- Extract version list to flat VERSIONS.txt file, read by Registry at runtime
- Add `rake versions` maintainer task to update VERSIONS.txt from GitHub releases
