# boxafe

[![Gem Version](https://badge.fury.io/rb/boxafe.png)](http://badge.fury.io/rb/boxafe)
[![Dependency Status](https://gemnasium.com/AlphaHydrae/boxafe.png)](https://gemnasium.com/AlphaHydrae/boxafe)
[![Build Status](https://secure.travis-ci.org/AlphaHydrae/boxafe.png)](http://travis-ci.org/AlphaHydrae/boxafe)

Boxafe mounts EncFS filesystems or "boxes" that you define in a configuration file with a friendly DSL.
It can also mount them on startup. [EncFS](http://www.arg0.net/encfs) must be installed separately.

**Note: Currently supports OS X. Partial Linux support.**

## Installation

    gem install boxafe

## Configuration

Location: `~/.boxafe.rb`

```rb
# mount a box (this will prompt for your password)
box do
  name 'A box'
  root '/secure/abox'
  mount '/Volumes/abox'
end
# this command is run:
# encfs "/secure/abox" "/Volumes/abox" -- -ovolname="A box"

# get the password from a file
box do
  name 'Password file box'
  root '/secure/password-file-box'
  mount '/Volumes/password-file-box'
  password_file '/secret/password'
end

# get the password from the OS X keychain
box do
  name 'Keychain box'
  root '/secure/keychain-box'
  mount '/Volumes/keychain-box'
  keychain 'keychain-box-password'
end
# adds an extpass to the command:
# --extpass="security 2>&1 >/dev/null find-generic-password -gl 'keychain-box-password'

# specify a custom path to the encfs XML configuration file
box do
  name 'Custom box'
  root '/secure/custom-box'
  mount '/Volumes/custom-box'
  encfs_config '/secure/.custom-box.encfs6.xml'
end
# adds an environment variable:
# ENCFS6_CONFIG="/secure/.custom-box.encfs6.xml"

# use a volume name different than the name
box do
  name 'Volume box'
  root '/secure/volume-box'
  mount '/Volumes/volume-box'
  volume 'Secure Volume'
end
# changes the ovolname option

# use a hash configuration
config = {
  name: 'Hash box',
  root: '/secure/hash-box',
  mount: '/Volumes/hash-box'
}
box config

# load configuration from environment variables
box env(:box_name, :box_root, :box_mount) # Reads $BOX_NAME, $BOX_ROOT, $BOX_MOUNT

# customize path to binaries
encfs '/opt/local/bin/encfs'
umount '/usr/local/bin/umount'
```

## Usage

```bash
# mount/unmount all defined boxes
boxafe mount
boxafe unmount

# mount/unmount one box
boxafe mount 'A box'
boxafe unmount 'A box'

# check what boxes are mounted
boxafe status

# mount all boxes on startup (currently only on OS X)
boxafe start

# stop boxes from mounting on startup
boxafe stop
```

## Compatibility

Boxafe is currently geared towards OS X with partial Linux support.

Cron scheduling is partially implemented with [whenever](https://github.com/javan/whenever),
and other extpass methods like a password file would be helpful.

## Contributing

* [Fork](https://help.github.com/articles/fork-a-repo)
* Create a topic branch - `git checkout -b my_branch`
* Push to your branch - `git push origin my_branch`
* Create a [pull request](http://help.github.com/pull-requests/) from your branch

Please add a changelog entry for new features and bug fixes.

Writing specs will get your code pulled faster.

## Roadmap

This is the list of planned features/changes:

* Complete test suite.
* Growl/OS X notifications.
* Get password from a file.
* Cron scheduling with [whenever](https://github.com/javan/whenever).

## Meta

* **Author:** Simon Oulevay (Alpha Hydrae)
* **License:** MIT (see [LICENSE.txt](https://raw.github.com/AlphaHydrae/boxafe/master/LICENSE.txt))
