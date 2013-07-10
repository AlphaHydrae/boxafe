# encoding: UTF-8

class Boxafe::Notifier
  IMPLEMENTATIONS = %w(growl notification_center)

  def self.notifier options = {}
    if options[:notify] == true
      platform_notifier options
    elsif IMPLEMENTATIONS.include?(name = options[:notify].to_s)
      notifier_instance name, options
    elsif options.key?(:notify) and options[:notify] != false
      raise Boxafe::Error, "Unknown notification type #{options[:notify].inspect}"
    end
  end

  def self.notifier_instance name, options = {}
    impl = Boxafe::Notifier.const_get(name.gsub(/(?:\A|_)(.)/){ $1.upcase })
    impl.available? ? impl.new(options) : nil
  end

  def self.platform_notifier options = {}

    candidates = case RbConfig::CONFIG['host_os']
    when /darwin/i
      %w(notification_center growl)
    else
      []
    end

    candidates.each do |name|
      notifier = notifier_instance name, options
      return notifier if notifier
    end

    nil
  end

  def initialize options = {}
    @options = { title: 'Boxafe' }.merge options
  end
end

Dir[File.join File.dirname(__FILE__), File.basename(__FILE__, '.*'), '*.rb'].each{ |lib| require lib }
