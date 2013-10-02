
module Boxafe

  class Validator

    def initialize options = {}
      @raise_first = options[:raise_first]
    end

    def validate options = {}
      validate_global_options(options) + validate_mount_options(options)
    end

    def validate_global_options options = {}
      
      errors = []
      encfs_bin, umount_bin = options[:encfs], options[:umount]

      add "could not find encfs binary '#{encfs_bin}'; is it in the PATH?", :encfs, errors unless Which.which encfs_bin
      add "could not find umount binary '#{umount_bin}'; is it in the PATH?", :umount, errors unless Which.which umount_bin

      errors
    end

    def validate_mount_options options = {}

      errors = []

      validate_file :root, 'root directory', options[:root], errors, required: true
      validate_file :mount, 'mount directory', options[:mount], errors, required: true, presence: false
      validate_file :password_file, 'password file', options[:password_file], errors, file: true
      validate_file :config_file, 'config file', options[:config_file], errors, file: true

      if options[:password_file] and options[:keychain]
        add "cannot use both a password file and the keychain", :keychain, errors
      end

      errors
    end

    private

    def validate_file option, name, file, errors, options = {}

      file = file ? File.expand_path(file.to_s) : nil

      if !file
        add "#{name} is required", option, errors if options[:required]
      elsif !File.exists?(file)
        add "#{file} does not exist", option, errors if options[:presence] != false
      elsif !options[:file] && !File.directory?(file)
        add "#{file} is not a directory", option, errors
      elsif options[:file] && !File.file?(file)
        add "#{file} is not a file", option, errors
      elsif options[:file] && !File.readable?(file)
        add "#{file} is not readable by the current user", option, errors
      end
    end

    def add msg, option = nil, errors = []
      OptionError.new(msg, option).tap do |e|
        if @raise_first
          raise e
        else
          errors << e
        end
      end
    end
  end
end
