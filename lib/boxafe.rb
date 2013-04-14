# encoding: UTF-8
require 'paint'
require 'dotenv'
require 'mutaconf'

module Boxafe
  VERSION = '0.0.1'
end

dir = File.join File.dirname(__FILE__), 'boxafe'
%w(box config encfs controller schedule).each{ |lib| require File.join dir, lib }
