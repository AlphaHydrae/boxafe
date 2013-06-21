require 'commander'

class Boxafe::Program < Commander::Runner

  BACKTRACE_NOTICE = ' (use --trace to view backtrace)'
  GLOBAL_OPTIONS = [ :config, :verbose ]

  include Commander::UI
  include Commander::UI::AskForClass

  def initialize argv = ARGV
    super argv

    program :name, 'boxafe'
    program :version, Boxafe::VERSION
    program :description, 'Secure your Dropbox with encfs.'

    global_option '-c', '--config PATH', 'Use a custom configuration file (defaults to ~/.boxafe.rb)'
    global_option '--verbose', 'Increase verbosity'

    command :info do |c|
      c.syntax = 'boxafe info'
      c.description = 'Display the current configuration (default action)'
      c.action do |args,options|
        controller.info extract(options)
      end
    end

    command :mount do |c|
      c.syntax = 'boxafe mount'
      c.description = 'Mount configured boxes with EncFS'
      c.action do |args,options|
        controller.mount *args
      end
    end

    command :unmount do |c|
      c.syntax = 'boxafe unmount'
      c.description = 'Unmount configured boxes'
      c.action do |args,options|
        controller.unmount *args
      end
    end

    command :start do |c|
      c.syntax = 'boxafe start'
      c.description = 'Configure boxafe to run on startup'
      c.action do |args,options|
        controller.start *(args.push extract(options))
      end
    end

    command :stop do |c|
      c.syntax = 'boxafe stop'
      c.description = 'Stop boxafe from running on startup'
      c.action do |args,options|
        controller.stop *(args.push extract(options))
      end
    end

    default_command :info
  end

  private

  def controller
    Boxafe::Controller.new
  end

  def to_trace_or_not_to_trace trace = false
    begin
      yield
    rescue Boxafe::Error => e
      if trace
        raise e
      else
        warn Paint["#{e.message}#{BACKTRACE_NOTICE}", :red]
        exit e.code
      end
    end
  end

  def extract *args
    options = args.pop
    (args | GLOBAL_OPTIONS).inject({}){ |memo,k| memo[k] = options.__send__(k); memo }.reject{ |k,v| v.nil? }
  end
end
