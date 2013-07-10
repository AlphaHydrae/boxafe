# encoding: UTF-8
require 'fileutils'

class Boxafe::Box

  OPTION_KEYS = [ :name, :root, :mount, :volume, :encfs_config, :keychain ]

  def initialize options = {}

    raise Boxafe::Error, "The :name option is required" unless options[:name]

    @options = options
  end

  def name
    @options[:name]
  end

  def mount
    system encfs.command
  end

  def unmount
    opts = options
    result = system "#{opts[:umount]} #{opts[:mount]}"
    sleep opts[:umount_delay] if opts[:umount_delay] and opts[:umount_delay] > 0
    result
  end

  def encfs
    Boxafe::Encfs.new options
  end

  def ensure_mount_point
    FileUtils.mkdir_p options[:mount]
  end

  def description verbose = false
    opts = options
    String.new.tap do |s|

      s << Paint["## #{name}", :cyan, :bold]
      s << "\nEncrypted Root: "
      s << if File.directory?(opts[:root])
        Paint["#{opts[:root]}", :green]
      elsif File.exists?(opts[:root])
        Paint["#{opts[:root]} (not a directory)", :red]
      else
        Paint["#{opts[:root]} (doesn't exist)", :red]
      end

      s << "\nMount Point: "
      s << case mount_status
      when :mounted
        Paint["#{opts[:mount]}", :green]
      when :invalid
        Paint["#{opts[:mount]} (not a directory)", :red]
      else
        Paint["#{opts[:mount]} (not mounted)", :yellow]
      end

      s << "\nVolume Name: #{opts[:volume]}"
      s << "\nKeychain Password: #{opts[:keychain]}" if opts[:keychain]
      s << "\nEncFS Config: #{opts[:encfs_config]}" if opts[:encfs_config]

      s << "\nCommand: #{Paint[encfs.command, :yellow]}" if verbose
    end
  end

  def mount_status
    if File.directory? options[:mount]
      :mounted
    elsif File.exists? options[:mount]
      :invalid
    else
      :unmounted
    end
  end

  def configure options = {}, &block
    @options.merge! options
    DSL.new(@options).instance_eval &block if block
    self
  end

  def options
    @options.tap do |opts|
      opts[:root] = File.expand_path opts[:root] || "~/Dropbox/#{opts[:name]}"
      opts[:mount] = File.expand_path opts[:mount] || "/Volumes/#{opts[:name]}"
      opts[:encfs_config] = File.expand_path opts[:encfs_config] if opts[:encfs_config]
      opts[:volume] ||= opts[:name]
      opts[:keychain] = opts[:name] if opts[:keychain] == true
    end
  end

  class DSL

    def initialize options
      @options = options
    end

    OPTION_KEYS.each{ |name| define_method(name){ |value| @options[name] = value } }
  end
end
