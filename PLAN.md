# bootstrap-vendor Implementation Plan

## Architecture

```txt
lib/
  bootstrap/
    vendor.rb                  # Main entry, requires all pieces
    vendor/
      version.rb               # (exists)
      config.rb                # ENV var handling, defaults, file path defaults
      registry.rb              # Hardcoded list of all Bootstrap versions
      file_list.rb             # Expected/installed files, downloads from jsdelivr CDN
      version_file.rb          # Reads/writes .bootstrap-version
      railtie.rb               # Loads rake tasks into Rails apps
  tasks/
    bootstrap.rake             # All rake task definitions

spec/
  bootstrap/
    vendor/
      config_spec.rb
      registry_spec.rb
      file_list_spec.rb
      version_file_spec.rb
    vendor_spec.rb
```

## Implementation Order

Each step is a TDD cycle: spec → pass → commit.

### Phase 1: Version knowledge

1. **Registry** — hardcoded list of all Bootstrap release versions.
   - `Registry.all` → sorted array of version strings
   - `Registry.latest` → latest overall
   - `Registry.latest(constraint:)` → latest matching '5', '5.3', '4', etc.
   - Error for unknown/invalid constraints

2. **VersionFile** — reads/writes `.bootstrap-version`.
   - `VersionFile.new(path:).read` → version string or nil
   - `VersionFile.new(path:).write(version:)`
   - `VersionFile.new(path:).exists?`
   - Handles path as dir (appends `.bootstrap-version`) or file

### Phase 2: Config & file list

3. **Config** — reads ENV vars, provides defaults.
   - `Config.new.css_ltr?` → true (default)
   - `Config.new.css_rtl?` → false (default)
   - `Config.new.css_map?` → true (default)
   - `Config.new.css_min?` → false (default)
   - `Config.new.js_bundle?` → true (default)
   - `Config.new.js_map?` → true (default)
   - `Config.new.js_min?` → false (default)
   - `Config.new.css_path` → 'vendor/stylesheets'
   - `Config.new.js_path` → 'vendor/javascript'

4. **FileList** — expected files, installed files, and downloading.
   - `FileList.new(config:, version:).expected` → array of {url:, destination:}
   - `FileList.new(config:, version:).installed` → array of destination paths that exist on disk
   - `FileList.new(config:, version:).download` → downloads expected files, prints progress
   - Uses `Down` gem with `http.rb` backend

### Phase 3: Rake tasks

5. **Railtie** — wires rake tasks into Rails.

6. **Rake tasks** — one at a time, in this order:
   a. `bootstrap:version` (simplest, just reads file)
   b. `bootstrap:latest` (uses Registry)
   c. `bootstrap:status` (compares version file to latest)
   d. `bootstrap:init` (creates version file)
   e. `bootstrap:install` (downloads files)
   f. `bootstrap:update` (install with overwrite)
   g. `bootstrap:vendor` (orchestrator: init → latest → update)
   h. `bootstrap:uninstall` (deletes files)

## Future: CLI

After all phases above are complete, add a standalone CLI (no Rake dependency) exposing the same commands. Spec out when we get there.
