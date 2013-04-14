
module Boxafe

  class Config
    KEYS = [ :encfs, :umount ]
    attr_reader :boxes, :options

    def initialize
      @boxes = []
      @options = { encfs: 'encfs', umount: 'umount', name: :Boxafe }
    end

    def box name = nil, config = nil, &block

      if name.kind_of? Hash
        config = name
        name = name[:name]
      end
      name = (name || @options[:name]).to_s

      if block or !@boxes.find{ |b| b.name == name }
        @boxes.delete_if{ |b| b.name == name }
        Box.new(self, name).tap do |box|
          @boxes << box
          box.configure config, &block
        end
      end

      @boxes.find{ |b| b.name == name }
    end

    def configure file, &block
      @dsl ||= DSL.new(self, target: @options, keys: KEYS)
      @dsl.configure file, &block
    end

    class DSL < Mutaconf::DSL

      def initialize config, options = {}
        super options
        @config = config
      end

      def box *args, &block
        @config.box *args, &block
      end

      def env *args
        Mutaconf.env *args
      end
    end
  end
end
