
class Boxafe::CLI

  def start options = {}
    # TODO: allow to mount only specific boxes
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

    boxes = args.empty? ? config.boxes : args.collect{ |arg| config.boxes.find{ |box| box.name == arg } }

    puts
    boxes.each do |box|

      print "Mounting #{box.name}... "
      case box.mount_status
      when :mounted
        puts Paint['already mounted', :green]
        next
      when :invalid
        puts Paint['invalid mount point', :red]
        next
      end

      box.ensure_mount_point
      box.mount

      puts case box.mount_status
      when :mounted
        Paint['mounted', :green]
      else
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
