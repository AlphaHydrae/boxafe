# encoding: UTF-8
require 'fileutils'

module Boxafe

  class Box
    OPTION_KEYS = [ :name, :root, :mount, :volume, :encfs_config, :keychain, :password_file ]

    def initialize options = {}
      raise OptionError.new("The :name option is required", :name) unless options[:name]
      @options = options
      @validator = Validator.new raise_first: true
    end

    def name
      @options[:name]
    end

    def command
      encfs.command
    end

    def mount
      @validator.validate mount_options
      ensure_mount_point
      system command
    end

    def unmount
      options = mount_options
      result = system "#{options[:umount]} #{options[:mount]}"
      sleep options[:umount_delay] if options[:umount_delay] and options[:umount_delay] > 0
      result
    end

    def mounted?
      File.directory? mount_options[:mount]
    end

    def mount_options
      default_mount_options.merge(@options).tap do |options|
        options[:keychain] = @options[:name] if options[:keychain] == true
      end
    end

    def configure options = {}, &block
      @options.merge! options
      DSL.new(@options).instance_eval &block if block
      self
    end

    private

    def ensure_mount_point
      FileUtils.mkdir_p mount_options[:mount]
    end

    def encfs
      Boxafe::Encfs.new mount_options
    end

    def default_mount_options
      name = @options[:name]
      {
        # TODO: change default root and mount dirs depending on host os
        root: "~/Dropbox/#{name}",
        mount: "/Volumes/#{name}",
        volume: name
      }
    end

    class DSL

      def initialize options
        @options = options
      end

      OPTION_KEYS.each{ |name| define_method(name){ |value| @options[name] = value } }
    end
  end
end
