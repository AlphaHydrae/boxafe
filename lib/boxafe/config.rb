
module Boxafe

  class Config
    OPTION_KEYS = %w(encfs umount umount_delay).collect &:to_sym
    attr_reader :boxes, :options

    def initialize
      @boxes = []
      @options = { encfs: 'encfs', umount: 'umount', umount_delay: 0.5, name: :Boxafe }
    end

    def box options = {}, &block
      options[:name] ||= @options[:name]

      if block or !@boxes.find{ |b| b.name == options[:name] }
        @boxes.delete_if{ |b| b.name == options[:name] }
        Box.new(self, options).tap do |box|
          @boxes << box
          box.configure options, &block
        end
      end

      @boxes.find{ |b| b.name == options[:name] }
    end

    def configure file, &block
      DSL.new(self, @options).instance_eval File.read(file), file
      self
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
end
