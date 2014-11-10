# encoding: UTF-8
require 'commander'

class Boxafe::Program < Commander::Runner

  GLOBAL_OPTIONS = [ :config, :verbose ]
  BACKTRACE_NOTICE = ' (use --trace to view backtrace)'

  include Commander::UI
  include Commander::UI::AskForClass

  def initialize argv = ARGV
    super argv

    program :name, 'boxafe'
    program :version, Boxafe::VERSION
    program :description, 'Secure your Dropbox with encfs.'

    global_option '-c', '--config PATH', 'Use a custom configuration file (defaults to ~/.boxafe.rb)'
    global_option '--verbose', 'Increase verbosity'

    command :status do |c|
      c.syntax = 'boxafe status'
      c.description = 'Display the current status and configuration'
      c.action do |args,options|
        to_trace_or_not_to_trace options.trace do
          cli.status extract(options)
        end
      end
    end

    command :mount do |c|
      c.syntax = 'boxafe mount'
      c.description = 'Mount configured boxes with EncFS'
      c.action do |args,options|
        to_trace_or_not_to_trace options.trace do
          cli.mount *args
        end
      end
    end

    command :unmount do |c|
      c.syntax = 'boxafe unmount'
      c.description = 'Unmount configured boxes'
      c.action do |args,options|
        to_trace_or_not_to_trace options.trace do
          cli.unmount *args
        end
      end
    end

    command :start do |c|
      c.syntax = 'boxafe start'
      c.description = 'Configure boxafe to run on startup'
      c.action do |args,options|
        to_trace_or_not_to_trace options.trace do
          cli.start *(args.push extract(options))
        end
      end
    end

    command :stop do |c|
      c.syntax = 'boxafe stop'
      c.description = 'Stop boxafe from running on startup'
      c.action do |args,options|
        to_trace_or_not_to_trace options.trace do
          cli.stop *(args.push extract(options))
        end
      end
    end

    default_command :status
  end

  private

  def cli
    Boxafe::CLI.new
  end

  def to_trace_or_not_to_trace trace = false
    if trace
      yield
    else
      begin
        yield
      rescue Boxafe::Error => e
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
