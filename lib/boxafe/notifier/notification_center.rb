# encoding: UTF-8
require 'terminal-notifier-guard'

class Boxafe::Notifier::NotificationCenter < Boxafe::Notifier
  METHODS = {
    info: :notify,
    success: :success,
    failure: :failed
  }

  def self.available?
    TerminalNotifier::Guard.available?
  end

  def notify msg, options = {}
    method = METHODS[options.delete(:type)] || :notify
    TerminalNotifier::Guard.send method, msg, terminal_notifier_options(options)
  end

  private

  def terminal_notifier_options options = {}
    @options.dup.tap do |h|
      h[:title] = options[:title] if options[:title]
    end
  end
end
