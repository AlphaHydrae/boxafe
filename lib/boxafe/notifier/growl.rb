# encoding: UTF-8
require 'growl'

class Boxafe::Notifier::Growl < Boxafe::Notifier
  METHODS = {
    info: :notify_info,
    success: :notify_ok,
    failure: :notify_error
  }

  def self.available?
    ::Growl.installed?
  end

  def notify msg, options = {}
    method = METHODS[options.delete(:type)] || :notify_info
    ::Growl.send method, msg, growl_options(options)
  end

  private

  def growl_options options = {}
    @options.dup.tap do |h|
      h[:title] = options[:title] if options[:title]
    end
  end
end
