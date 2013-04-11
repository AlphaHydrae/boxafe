# encoding: UTF-8
require 'paint'

module Boxafe
  VERSION = '0.0.1'
end

dir = File.join File.dirname(__FILE__), 'boxafe'
%w(box config encfs controller).each{ |lib| require File.join dir, lib }
