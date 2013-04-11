require File.join File.dirname(__FILE__), 'boxafe'
require 'commander/import'

program :name, 'boxafe'
program :version, Boxafe::VERSION
program :description, 'Secure your Dropbox with encfs.'

global_option '-c', '--config PATH', 'Use a custom configuration file (defaults to ~/.boxafe.rb)'
global_option '--verbose', 'Increase verbosity'

command :info do |c|
  c.syntax = 'boxafe info'
  c.description = 'Display the current configuration (default action)'
  c.action do |args,options|
    Boxafe::Controller.new(options).info
  end
end

command :mount do |c|
  c.syntax = 'boxafe mount'
  c.description = 'Mount configured boxes with EncFS'
  c.action do |args,options|
    Boxafe::Controller.new(options).mount *args
  end
end

command :unmount do |c|
  c.syntax = 'boxafe unmount'
  c.description = 'Unmount configured boxes'
  c.action do |args,options|
    Boxafe::Controller.new(options).unmount *args
  end
end

default_command :info
