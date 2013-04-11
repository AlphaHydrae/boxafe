
module Boxafe

  class Config
    attr_reader :boxes

    def initialize
      @options = { encfs: 'encfs', umount: 'umount' }
      @box_options = { name: :Boxafe }
      @boxes = []
    end

    def options
      @options.merge @box_options
    end

    def box name = nil, &block
      name = (name || @name).to_s
      if block or !@boxes.find{ |b| b.name == name }
        @boxes.delete_if{ |b| b.name == name }
        Box.new(self, name).tap do |box|
          @boxes << box
          box.dsl.instance_eval &block
        end
      end
      @boxes.find{ |b| b.name == name }
    end

    def dsl
      DSL.new self, @options
    end

    class DSL < Box::DSL

      def initialize config, options = {}
        super options
        @config = config
      end

      def box *args, &block
        @config.box *args, &block
      end
    end
  end
end
