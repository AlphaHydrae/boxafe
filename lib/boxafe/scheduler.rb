
module Boxafe

  class Scheduler

    def self.platform_scheduler options = {}
      case RbConfig::CONFIG['host_os']
      when /darwin/i
        Scheduler::Launchd.new options
      else
        Scheduler::Cron.new options
      end
    end

    def initialize options = {}
      @options = options
    end
  end
end

Dir[File.join File.dirname(__FILE__), File.basename(__FILE__, '.*'), '*.rb'].each{ |lib| require lib }
