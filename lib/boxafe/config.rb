
class Boxafe::Config

  OPTION_KEYS = [ :encfs, :umount, :umount_delay ]

  attr_reader :boxes, :options

  def initialize options = {}
    @boxes = []
    @options = { encfs: 'encfs', umount: 'umount', umount_delay: 0.5, name: :Boxafe }.merge options
  end

  def box options = {}, &block
    options[:name] ||= @options[:name]

    if block or !@boxes.find{ |b| b.name == options[:name] }
      @boxes.delete_if{ |b| b.name == options[:name] }
      Boxafe::Box.new(self, options).tap do |box|
        @boxes << box
        box.configure options, &block
      end
    end

    @boxes.find{ |b| b.name == options[:name] }
  end

  def configure file = nil, &block
    DSL.new(self, @options).tap do |dsl|
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

    def initialize config, options = {}
      @config, @options = config, options
    end

    def box *args, &block
      @config.box *args, &block
    end

    def env *args
      Mutaconf.env *args
    end

    OPTION_KEYS.each do |name|
      define_method(name){ |value| @options[name.to_sym] = value }
    end
  end
end
