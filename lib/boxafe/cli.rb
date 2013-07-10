# encoding: UTF-8
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
    puts Paint["# Boxafe v#{Boxafe::VERSION}", :bold]

    config.boxes.each do |box|
      puts
      puts box.description(options[:verbose])
    end

    puts
  end

  def mount *args

    options = args.last.kind_of?(Hash) ? args.pop : {}
    config = load_config options

    # FIXME: crashes with unknown box names
    boxes = args.empty? ? config.boxes : args.collect{ |arg| config.boxes.find{ |box| box.name == arg } }

    notifier = Boxafe::Notifier.notifier config.options

    puts
    boxes.each do |box|

      print "Mounting #{box.name}... "
      case box.mount_status
      when :mounted
        notifier.notify "#{box.name} is already mounted" if notifier
        puts Paint['already mounted', :green]
        next
      when :invalid
        notifier.notify "#{box.name} has an invalid mount point (not a directory)", type: :failure if notifier
        puts Paint['invalid mount point (not a directory)', :red]
        next
      end

      box.ensure_mount_point
      box.mount

      puts case box.mount_status
      when :mounted
        notifier.notify "#{box.name} is mounted", type: :success if notifier
        Paint['mounted', :green]
      else
        notifier.notify "#{box.name} could not be mounted", type: :failure if notifier
        Paint['could not be mounted', :red]
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

      puts case box.mount_status
      when :unmounted
        Paint['unmounted', :green]
      else
        Paint['could not be unmounted', :red]
      end
    end

    puts
  end

  private

  def load_config options = {}
    Boxafe::Config.new(options).load
  end
end
