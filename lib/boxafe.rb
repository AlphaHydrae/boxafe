# encoding: UTF-8
require 'paint'
require 'dotenv'
require 'mutaconf'

module Boxafe
  VERSION = '0.0.1'

  # TODO: add detailed error description for non-trace mode
  class Error < StandardError
    attr_reader :code
    
    def initialize msg, code = 1
      super msg
      @code = code
    end
  end
end

Dir[File.join File.dirname(__FILE__), File.basename(__FILE__, '.*'), '*.rb'].each{ |lib| require lib }
