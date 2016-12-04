# encoding: UTF-8
require 'paint'
require 'dotenv'
require 'mutaconf'

module Boxafe
  VERSION = '0.1.6'

  # TODO: add detailed error description for non-trace mode
  class Error < StandardError
    attr_reader :code

    def initialize msg, code = 1
      super msg
      @code = code
    end
  end

  class OptionError < Error
    attr_reader :option

    def initialize msg, option = nil
      super msg
      @option = option
    end
  end
end

Dir[File.join File.dirname(__FILE__), File.basename(__FILE__, '.*'), '*.rb'].each{ |lib| require lib }
