require 'fileutils'

module Boxafe

  class Box

    def initialize config, name = nil
      @config, @options = config, {}
      @options[:name] = name if name
    end

    def name
      @options[:name]
    end

    def mount
      system encfs.command
    end

    def unmount
      system "#{options[:umount]} #{options[:mount]}"
    end

    def encfs
      Encfs.new options
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
        s << "\nEncFS Config: #{opts[:config]}" if opts[:config]

        s << "\nCommand: #{Paint[Encfs.new(opts).command, :yellow]}" if verbose
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

    def dsl
      DSL.new @options
    end

    def options
      @config.options.merge(@options).tap do |opts|
        opts[:root] = File.expand_path opts[:root] || "~/Dropbox/#{opts[:name]}"
        opts[:mount] = File.expand_path opts[:mount] || "/Volumes/#{opts[:name]}"
        opts[:volume] ||= opts[:name]
        opts[:keychain] = opts[:name] if opts[:keychain] == true
      end
    end

    class DSL

      def initialize options = {}
        @options = options
      end
        
      %w(name root mount volume config keychain).each do |name|
        define_method(name){ |arg| @options[name.to_sym] = arg }
      end
    end
  end
end
