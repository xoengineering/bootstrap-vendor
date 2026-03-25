# TODO

Make this into a gem that can be added to a Rails repo's `Gemfile`
which them gives them these rake tasks to check their bootstrap version/s,
checks upstream for latest version, compares status of installed
current version to latest upstream version, downloads, etc.

All of the rake tasks will be in a namespace: `bootstrap`

Eg, `rake bootstrap:init` `rake bootstrap:install` `rake bootstrap:update`

Some will allow arguments

Eg, `rake bootstrap:install['5.3.8']`

Its understanding of the user's version preference should work basically
like Bundler's squiggly proc. `5.3.8` `5.3` `5`

## Example workflows

Happy path!
Assumes the gem is installed and available in current shell session/PATH.
Assumes PWD is the root of a Rails app.

```sh
rake bootstrap:vendor
```

Manual path, from scratch:

```sh
rake bootstrap:init
rake bootstrap:version
rake bootstrap:latest
rake bootstrap:install
rake bootstrap:version
```

Manual path, from existing:

```sh
rake bootstrap:status
rake bootstrap:update
rake bootstrap:version
```

Complicated and complex:

```sh
rake bootstrap:init['overwrite']
rake bootstrap:version
rake bootstrap:status
BOOTSTRAP_VENDOR_CSS_LTR=false BOOTSTRAP_VENDOR_CSS_RTL=true BOOTSTRAP_VENDOR_CSS_MIN=true BOOTSTRAP_VENDOR_CSS_MAP=false BOOTSTRAP_VENDOR_JS_BUNDLE=false BOOTSTRAP_VENDOR_JS_MAP=false BOOTSTRAP_VENDOR_JS_MIN=true rake bootstrap:update
rake bootstrap:status
rake bootstrap:version
```

---

## bootstrap:vendor

Very opinionated does it all shortcut.

1. Reads or creates .bootstrap-version file
2. Downloads latest version of Bootstrap CSS/JS files
   - vendor/stylesheets/bootstrap.css
   - vendor/stylesheets/bootstrap.css.map
   - vendor/javascript/bootstrap.bundle.js
   - vendor/javascript/bootstrap.bundle.js.map
3. Updates .bootstrap-version to latest version
4. Prints its progress

This is actually just calling other Rake tasks (described below):

```sh
bootstrap:init
bootstrap:latest
bootstrap:update
```



## bootstrap:latest

Fetches the version number of the latest known upstream version.

Output:

```sh
rake bootstrap:latest
5.3.8
```

Optional arg: `version` String, can be an `Integer`, gets `String()` to string.
Check for the latest known version within that major/minor/patch level.

```sh
rake bootstrap:latest[5]
5.3.8

rake bootstrap:latest['5']
5.3.8

rake bootstrap:latest['4']
4.6.2

rake bootstrap:latest['5.3.5']
5.3.8

rake bootstrap:latest['5.3']
5.3.8

rake bootstrap:latest['5.2']
5.2.3
```

Versions below the current support major/minor versions isn't getting updates.
So, we can hardcode a list of all past versions, instead of phoning home.

## bootstrap:version

Prints the content of `.bootstrap-version`.
Optional arg: path.
If none, print message that there isn't one.

```sh
rake bootstrap:version
5.3.8

# as dir path: with ~/Developer/xoengineering/website/.bootstrap-version file
rake bootstrap:version['~/Developer/xoengineering/website']
5.3.8

# as file path: with ~/Developer/xoengineering/website/.bootstrap-version file
rake bootstrap:version['~/Developer/xoengineering/website/.bootstrap-version']
5.3.8

# with no .bootstrap-version file found at the default or given path
rake bootstrap:version
No .bootstrap-version file found. Create one with:
rake bootstrap:init
```

## bootstrap:status

Compares my current version, from `.bootstrap-version` with upstream.
Default, compares mine to latest upstream.
With a `version` arg, compares to latest of that major/minor/patch.
Just like `bootstrap:latest`.

```sh
rake bootstrap:status
Current version 5.3.8 is up to date

rake bootstrap:status
Current version 1.2.3 is behind latest version 5.3.8

rake bootstrap:status[5]
Current version 1.2.3 is behind latest 5.x.y version 5.3.8

rake bootstrap:status['5']
Current version 1.2.3 is behind latest 5.x.y version 5.3.8

rake bootstrap:status['4']
Current version 1.2.3 is behind latest 4.x.y version 5.3.8

rake bootstrap:status['5.3.5']
Current version 1.2.3 is behind latest 5.3.x version 5.3.8

rake bootstrap:status['5.3']
Current version 1.2.3 is behind latest 5.3.x version 5.3.8

rake bootstrap:status['5.2']
Current version 1.2.3 is behind latest 5.3.x version 5.2.3
```

## bootstrap:init

Creates a .bootstrap-version file.
Optional args: version, path
version: default `'latest'`, optional: major/minor/patch.
  Like bootstrap:status.
path: default `'./.bootstrap-versions'`, optional: dir or file path.
  Like bootstrap:version.

```sh
# with a .bootstrap-version file found at the location of PWD
rake bootstrap:init
A .bootstrap-version file already exists. 
Version: 5.2.3
Use 'overwrite' to replace it.
rake bootstrap:init['overwrite']

# with no .bootstrap-version file found at the location of PWD
rake bootstrap:init
A .bootstrap-version file was created. 
Version: 5.3.8

# optional arg: version
rake bootstrap:init[5]
A .bootstrap-version file was created. 
Version: 5.3.8

rake bootstrap:init['5']
A .bootstrap-version file was created. 
Version: 5.3.8

rake bootstrap:init['5.2']
A .bootstrap-version file was created. 
Version: 5.2.3

rake bootstrap:init['4']
A .bootstrap-version file was created. 
Version: 4.6.2

rake bootstrap:init['3.3.1']
A .bootstrap-version file was created. 
Version: 3.3.7

# with a path arg, same as above, 
rake bootstrap:init['latest', '~/xoengineering/website']
A ~/xoengineering/website/.bootstrap-version file already exists. 
Version: 5.2.3
Use 'overwrite' to replace it.
rake bootstrap:init['latest', '~/xoengineering/website', 'overwrite']
```

## bootstrap:install

Downloads Bootstrap CSS and JS from upstream.
Args: version, path.
`version` defaults to `latest`. Other version values behave like above.
`path` same as above. Default: `./bootstrap-version`.
Same check for existing, prints error. Allows `overwrite` arg.

```sh
rake bootstrap:install
CSS:
  vendor/stylesheets/bootstrap.css
  vendor/stylesheets/bootstrap.css.map
JS:
  vendor/javascript/bootstrap.js
  vendor/javascript/bootstrap.js.map
```

## bootstrap:update

Same as bootstrap:install with overwrite.
Downloads Bootstrap CSS and JS from upstream.
Args: version, path.
`version` defaults to `latest`. Other version values behave like above.
`path` same as above. Default: `./bootstrap-version`.
Same check for existing, prints error. Allows `overwrite` arg.

```sh
rake bootstrap:updated
Bootstrap updated from 5.3.2 to 5.3.8

CSS:
  vendor/stylesheets/bootstrap.css
  vendor/stylesheets/bootstrap.css.map
Bootstrap:
  vendor/javascript/bootstrap.js
  vendor/javascript/bootstrap.js.map
```

## bootstrap:uninstall

Deletes files. Optional args: dry_run, version_path, css_path, js_path.
dry_run: Boolean defaults to false. If true, prints what it would do but didn't.
version_path: path/to/.boostrap-version file. Default: ./.bootstrap-version
css_path: Default: vendor/stylesheets
js_path: Default: vendor/javascript

# Supported ENV variables

Opinionated defaults but overrides allowed. Convention over configuration.

`ENV` vars that can used and their default values.

```sh
BOOTSTRAP_VENDOR_CSS_LTR=true
BOOTSTRAP_VENDOR_CSS_RTL=false
BOOTSTRAP_VENDOR_CSS_MAP=true
BOOTSTRAP_VENDOR_CSS_MIN=false

BOOTSTRAP_VENDOR_JS_BUNDLE=true
BOOTSTRAP_VENDOR_JS_MAP=true
BOOTSTRAP_VENDOR_JS_MIN=false
```

CSS file permutations:

- bootstrap.css # default
- bootstrap.css.map # default
- bootstrap.min.css
- bootstrap.min.css.map
- bootstrap.rtl.css
- bootstrap.rtl.css.map
- bootstrap.rtl.min.css
- bootstrap.rtl.min.css.map

JS file permutations:

- bootstrap.bundle.js
- bootstrap.bundle.js.map
- bootstrap.bundle.min.js
- bootstrap.bundle.min.js.map
- bootstrap.js # default
- bootstrap.js.map # default
- bootstrap.min.js
- bootstrap.min.js.map

---

# Dev context

## Gem dependencies

For `.gemspec`.

```ruby
gem 'down'
gem 'http'
```

## Bootstrap version file

.bootstrap-version

```txt
5.3.8
```

## Starting place

This is my simple, works for me, but not for everyone rake task.
This is a good starting place. It has the core opinions.

```ruby
require 'down'
require 'json'

namespace :bootstrap do
  desc 'Check for Bootstrap updates and download if newer version available'
  task :download do
    version_file = Rails.root.join '.bootstrap-version'
    current_version = version_file.exist? ? version_file.read.strip : '0.0.0'

    print 'Checking for Bootstrap updates... '

    response       = HTTP.get 'https://api.github.com/repos/twbs/bootstrap/releases/latest'
    latest         = JSON.parse response.body.to_s
    latest_version = latest['tag_name'].delete_prefix 'v'

    puts "updating from #{current_version} to #{latest_version}"

    css_url     = "https://cdn.jsdelivr.net/npm/bootstrap@#{latest_version}/dist/css/bootstrap.css"
    css_map_url = "https://cdn.jsdelivr.net/npm/bootstrap@#{latest_version}/dist/css/bootstrap.css.map"
    js_url      = "https://cdn.jsdelivr.net/npm/bootstrap@#{latest_version}/dist/js/bootstrap.bundle.js"
    js_map_url  = "https://cdn.jsdelivr.net/npm/bootstrap@#{latest_version}/dist/js/bootstrap.bundle.js.map"

    css_dir = Rails.root.join 'vendor/stylesheets'
    js_dir  = Rails.root.join 'vendor/javascript'

    FileUtils.mkdir_p css_dir
    FileUtils.mkdir_p js_dir

    Down.download css_url,     destination: css_dir.join('bootstrap.css').to_s
    Down.download css_map_url, destination: css_dir.join('bootstrap.css.map').to_s
    Down.download js_url,      destination: js_dir.join('bootstrap.js').to_s
    Down.download js_map_url,  destination: js_dir.join('bootstrap.js.map').to_s

    version_file.write latest_version
    puts "Bootstrap #{latest_version} downloaded to vendor/javascript/bootstrap.*"
  end
end
```
