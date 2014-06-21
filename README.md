# librarian-repo

Fork of the the librarian-puppet-simple project. (https://github.com/bodepd/librarian-puppet-simple)

As I needed to pull some repos at build time, and already was using librarian-puppet,
I needed different binary/xxxfile/container names. This project also supports zip archives.

### Clean
Remove the directory where the repos will be installed. At the moment the supported options are:
* `--verbose` display progress messages
* `--path` override the default `./repos` where repos will be installed

```
  librarian-repo clean [--verbose] [--path]
```

### Install
Iterates through your Repofile and installs git sources. At the moment the supported options are:
* `--verbose` display progress messages
* `--clean` remove the directory before installing repos
* `--path` override the default `./repos` where repos will be installed
* `--Repofile` override the default `./Repofile` used to find the repos

```
  librarian-repo install [--verbose] [--clean] [--path] [--Repofile]
```

### Update
Iterates through your Repofile and updates git sources. If a SHA-1 hash is specified in the `:ref`, the module will not be updated.

Supported options are:<br/>
<li>`--verbose` display progress messages</li>
<li>`--path` override the default `./repos` where repos will be installed</li>
<li> `--Repofile` override the default `./Repofile` used to find the repos</li>

```
  librarian-repo update [--verbose] [--path] [--Repofile]
```

## Repofile
The processed Repofile may contain two different types of repos, `git` and `archive`. The `git` option accepts an optional `ref` parameter.
`archive` supoorts tar.gz and zip format.

The module names can be namespaced, but the created directory will only contain the last part of the name. For example, a module named `puppetlabs/ntp` will generate a directory `ntp`, and so will a module simply named `ntp`.

Here's an example of a valid Repofile showcasing all valid options:

```
mod "puppetlabs/ntp",
    :git => "git://github.com/puppetlabs/puppetlabs-ntp.git",
    :ref => "99bae40f225db0dd052efbf1d4078a21f0333331"

mod "apache",
    :archive => "https://forge.puppetlabs.com/puppetlabs/apache/0.6.0.tar.gz"
```

## Setting up for development and running the specs
Just clone the repo and run the following commands:
```
bundle exec install --path=vendor
bundle exec rspec
```

Beware that the functional tests will download files from GitHub and will break if either is unavailable.

## License

See [LICENSE](/LICENSE)

## Credits
The main project came form https://github.com/bodepd/librarian-puppet-simple
The untar and ungzip methods came from https://gist.github.com/sinisterchipmunk/1335041