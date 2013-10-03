# encoding: UTF-8
require 'notifies'
require 'which_works'

class Boxafe::CLI

  def start options = {}
    # TODO: allow to mount only specific boxes
    # TODO: only allow boxes with an extpass
    Boxafe::Scheduler.platform_scheduler(options).start
  end

  def stop options = {}
    Boxafe::Scheduler.platform_scheduler(options).stop
  end

  def status options = {}

    config = load_config options

    puts
    puts global_description(config, options[:verbose])

    config.boxes.each do |box|
      puts
      puts box_description(box, options[:verbose])
    end

    puts
  end

  def mount *args

    options = args.last.kind_of?(Hash) ? args.pop : {}
    config = load_config options

    # FIXME: crashes with unknown box names
    boxes = args.empty? ? config.boxes : args.collect{ |arg| config.boxes.find{ |box| box.name == arg } }

    puts
    boxes.each do |box|

      print "Mounting #{box.name}... "
      if box.mounted?
        notify :info, "#{box.name} is already mounted", config.options
        puts Paint['already mounted', :green]
        next
      end

      begin
        box.mount
      rescue OptionError => e
        msg = ":#{e.option} option error - #{e.message}"
        notify :error, "#{box.name} #{msg}", config.options
        puts Paint[msg, :red]
        next
      end

      if box.mounted?
        notify :ok, "#{box.name} is mounted", config.options
        puts Paint['mounted', :green]
      else
        notify :error, "#{box.name} could not be mounted", config.options
        puts Paint['could not be mounted', :red]
      end
    end

    puts
  end

  def unmount *args

    options = args.last.kind_of?(Hash) ? args.pop : {}
    config = load_config options

    boxes = args.empty? ? config.boxes : args.collect{ |arg| config.boxes.find{ |box| box.name == arg } }

    puts
    boxes.each do |box|

      print "Umounting #{box.name}... "
      box.unmount

      if box.mounted?
        puts Paint['could not be unmounted', :red]
      else
        puts Paint['unmounted', :green]
      end
    end

    puts
  end

  private

  def global_description config, verbose = false

    Array.new.tap do |a|

      a << Paint["Boxafe v#{Boxafe::VERSION}", :bold]
      # TODO: show notifications status

      if verbose

        encfs_bin, umount_bin = config.options[:encfs], config.options[:umount]
        errors = Boxafe::Validator.new.validate_global_options config.options

        a << "EncFS binary: #{option_value :encfs, encfs_bin, errors}"
        a << "umount binary: #{option_value :umount, umount_bin, errors}"
        # TODO: show umount delay if verbose
      end
    end.join "\n"
  end

  def box_description box, verbose = false

    options = box.mount_options
    errors = Boxafe::Validator.new.validate_mount_options options

    root_str = option_value :root, options[:root], errors
    mount_str = option_value :mount, options[:mount], errors, box.mounted? ? nil : "not mounted"

    if options[:verbose]

      Array.new.tap do |a|

        a << Paint["## #{box.name}", :cyan, :bold]
        a << "Encrypted Root: #{root_str}"
        a << "Mount Point: #{mount_str}"
        a << "Password File: #{option_value :password_file, options[:password_file], errors}" if options[:password_file]
        a << "Keychain Password: #{option_value :keychain, options[:keychain], errors}" if options[:keychain]
        a << "EncFS Config: #{option_value :encfs_config, options[:encfs_config], errors}" if options[:encfs_config]
        a << "Command: #{Paint[box.command, :cyan]}" if verbose

        errors.each do |e|
          a << Paint[":#{e.option} option error - #{e.message}", :red]
        end
      end.join "\n"
    else

      String.new.tap do |s|

        s << %|#{Paint["#{box.name}:", :bold, :cyan]} #{root_str} -> #{mount_str}|

        errors.each do |e|
          s << "\n" + " " * (box.name.length + 2)
          s << Paint[":#{e.option} option error - #{e.message}", :red]
        end
      end
    end
  end

  def option_value name, value, errors, warning = nil
    if error = errors.find{ |e| e.option == name }
      Paint[value, :red]
    elsif warning
      Paint["#{value} (#{warning})", :yellow]
    else
      Paint[value, :green]
    end
  end

  def load_config options = {}
    Boxafe::Config.new(options).load
  end

  def notify type, msg, options = {}
    return unless options[:notify]
    Notifies.notify msg, type: type
  end
end
