
module Boxafe

  class Controller

    def initialize options
      @options = options
    end

    def info

      config = load_config

      puts
      puts Paint["# Boxafe v#{VERSION}", :bold]

      config.boxes.each do |box|
        puts
        puts box.description(@options.verbose)
      end

      puts
    end

    def mount *args

      config = load_config
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
      
      config = load_config
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

    def load_config
      Config.new.tap do |config|
        config.dsl.instance_eval read_config, config_file
      end
    end

    def read_config
      File.open(config_file, 'r').read
    end

    def config_file
      @config_file ||= File.expand_path([ @options.config, ENV['BOXAFE_CONFIG'], "~/.boxafe.rb" ].compact.first)
    end
  end
end
