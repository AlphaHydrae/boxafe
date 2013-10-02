# encoding: UTF-8
class Boxafe::Config

  # TODO: document unmount_delay
  # TODO: add option to chdir, boxes relative to working directory when calling start by default
  OPTION_KEYS = [ :encfs, :umount, :umount_delay, :notify ]

  attr_reader :boxes, :options

  def initialize options = {}
    @boxes = []
    @options = { encfs: 'encfs', umount: 'umount', umount_delay: 0.5 }.merge options
  end

  def configure file = nil, &block
    DSL.new(self).tap do |dsl|
      dsl.instance_eval File.read(file), file if file
      dsl.instance_eval &block if block
    end
    self
  end

  def load
    configure file
  end

  def file
    File.expand_path [ @options[:config], ENV['BOXAFE_CONFIG'], "~/.boxafe.rb" ].compact.first
  end

  class DSL

    def initialize config
      @config = config
    end

    def box options = {}, &block
      Boxafe::Box.new(@config.options.merge(options)).tap do |box|
        @config.boxes << box.configure(&block)
      end
    end

    def env *args
      Mutaconf.env *args
    end

    OPTION_KEYS.each do |name|
      define_method(name){ |value| @config.options[name.to_sym] = value }
    end
  end
end
