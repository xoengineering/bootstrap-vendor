# bootstrap-vendor

Rake tasks to vendor [Bootstrap](https://getbootstrap.com) CSS and JS into your Rails app. No asset pipeline, no npm, no build system. Just static files in `vendor/`.

## Install

Add to your Gemfile:

```ruby
gem 'bootstrap-vendor'
```

Then:

```sh
bundle install
```

In a Rails app, the rake tasks are loaded automatically via Railtie.

## Quick start

```sh
rake bootstrap:vendor
```

This creates a `.bootstrap-version` file and downloads the latest Bootstrap CSS and JS into `vendor/stylesheets/` and `vendor/javascript/`.

## Usage

### In Rails

Add Bootstrap to your asset paths. In `config/initializers/assets.rb`:

```ruby
Rails.application.config.assets.paths << Rails.root.join('vendor/stylesheets')
Rails.application.config.assets.paths << Rails.root.join('vendor/javascript')
```

Or with importmaps, pin the JS in `config/importmap.rb`:

```ruby
pin 'bootstrap', to: 'bootstrap.bundle.js'
```

And add a stylesheet link in your layout:

```erb
<%= stylesheet_link_tag 'bootstrap', 'data-turbo-track': 'reload' %>
```

### In non-Rails

Add the gem:

```sh
gem install bootstrap-vendor
```

Create a `Rakefile` (or add to an existing one):

```ruby
require 'bootstrap/vendor'
load 'tasks/bootstrap.rake'
```

Then use the rake tasks as normal:

```sh
rake bootstrap:vendor
```

### From zsh (command line shell)

zsh interprets `[]` as glob patterns. Escape the brackets when passing arguments to rake tasks:

```sh
rake 'bootstrap:init[overwrite]'
rake bootstrap:init\[overwrite\]
noglob rake bootstrap:init[overwrite]
```

## Rake tasks

- [`bootstrap:vendor`](#bootstrapvendor) — do it all shortcut
- [`bootstrap:version`](#bootstrapversion) — print current version
- [`bootstrap:latest`](#bootstraplatest) — print latest upstream version
- [`bootstrap:status`](#bootstrapstatus) — compare current to latest
- [`bootstrap:init`](#bootstrapinit) — create .bootstrap-version
- [`bootstrap:install`](#bootstrapinstall) — download files
- [`bootstrap:update`](#bootstrapupdate) — update files
- [`bootstrap:uninstall`](#bootstrapuninstall) — remove files

### `bootstrap:vendor`

The opinionated, does-it-all shortcut. Creates `.bootstrap-version`, downloads the latest Bootstrap files, and you're done.

```sh
rake bootstrap:vendor
```

### `bootstrap:version`

Prints the current version from `.bootstrap-version`.

```sh
rake bootstrap:version
# 5.3.8
```

### `bootstrap:latest`

Prints the latest known Bootstrap version. Accepts an optional constraint.

```sh
rake bootstrap:latest
# 5.3.8

rake bootstrap:latest[5]
# 5.3.8

rake bootstrap:latest[4]
# 4.6.2

rake bootstrap:latest[5.2]
# 5.2.3
```

### `bootstrap:status`

Compares your current version to the latest upstream.

```sh
rake bootstrap:status
# Current version 5.3.8 is up to date

rake bootstrap:status
# Current version 5.2.3 is behind latest version 5.3.8
```

### `bootstrap:init`

Creates a `.bootstrap-version` file. Defaults to the latest version.

```sh
rake bootstrap:init
# A .bootstrap-version file was created.
# Version: 5.3.8

rake bootstrap:init[4]
# A .bootstrap-version file was created.
# Version: 4.6.2

rake bootstrap:init[overwrite]
# Overwrites an existing .bootstrap-version
```

### `bootstrap:install`

Downloads Bootstrap CSS and JS files. Fails if already installed (use `update` instead).

```sh
rake bootstrap:install
```

### `bootstrap:update`

Downloads Bootstrap CSS and JS files, overwriting existing ones.

```sh
rake bootstrap:update
# Bootstrap updated from 5.3.5 to 5.3.8
```

### `bootstrap:uninstall`

Removes vendored Bootstrap files and `.bootstrap-version`.

```sh
rake bootstrap:uninstall
```

## Default files

By default, these files are downloaded:

```sh
vendor/stylesheets/bootstrap.css
vendor/stylesheets/bootstrap.css.map
vendor/javascript/bootstrap.bundle.js
vendor/javascript/bootstrap.bundle.js.map
```

### Configuration

Customize which files are downloaded with environment variables. These are the defaults:

| ENV variable                 | Default | Effect                                     |
| ---------------------------- | ------- | ------------------------------------------ |
| `BOOTSTRAP_VENDOR_CSS_LTR`   | `true`  | Download LTR CSS                           |
| `BOOTSTRAP_VENDOR_CSS_RTL`   | `false` | Download RTL CSS                           |
| `BOOTSTRAP_VENDOR_CSS_MAP`   | `true`  | Download CSS source maps                   |
| `BOOTSTRAP_VENDOR_CSS_MIN`   | `false` | Download minified CSS                      |
| `BOOTSTRAP_VENDOR_JS_BUNDLE` | `true`  | Download bundle (includes Popper) vs plain |
| `BOOTSTRAP_VENDOR_JS_MAP`    | `true`  | Download JS source maps                    |
| `BOOTSTRAP_VENDOR_JS_MIN`    | `false` | Download minified JS                       |

At least one of `CSS_LTR` or `CSS_RTL` must be `true`.

Example: download minified files without source maps:

```sh
BOOTSTRAP_VENDOR_CSS_MIN=true BOOTSTRAP_VENDOR_CSS_MAP=false BOOTSTRAP_VENDOR_JS_MIN=true BOOTSTRAP_VENDOR_JS_MAP=false rake bootstrap:install
```

## Download sources

Files are downloaded from multiple sources with automatic fallback for resilience:

1. [jsdelivr CDN](https://www.jsdelivr.com) (npm)
2. [jsdelivr CDN](https://www.jsdelivr.com) (GitHub)
3. [GitHub raw files](https://raw.githubusercontent.com)
4. [GitHub releases](https://github.com/twbs/bootstrap/releases) (zip)

Pin a specific source with:

```sh
BOOTSTRAP_VENDOR_SOURCE=github_raw rake bootstrap:install
```

Valid source names: `jsdelivr_npm`, `jsdelivr_github`, `github_raw`, `github_api`.

## Version constraints

Several tasks accept version constraints. The constraint finds the latest version within that major or minor:

| Constraint | Resolves to                |
| ---------- | -------------------------- |
| `5`        | Latest 5.x.y (e.g., 5.3.8) |
| `5.3`      | Latest 5.3.x (e.g., 5.3.8) |
| `5.3.5`    | Latest 5.3.x (e.g., 5.3.8) |
| `4`        | Latest 4.x.y (e.g., 4.6.2) |

## Requirements

- Ruby >= 4.0
- Rails (for automatic Railtie loading) or any Ruby project with Rake

## License

MIT. See [LICENSE.txt](LICENSE.txt).
