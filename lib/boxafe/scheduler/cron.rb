# encoding: UTF-8
#require 'whenever'

class Boxafe::Scheduler::Cron < Boxafe::Scheduler

  def start
    raise 'Not yet implemented on this operating system'
    Whenever::CommandLine.execute block: mount_schedule, write: true, identifier: 'boxafe-mount'
  end

  def stop
    raise 'Not yet implemented on this operating system'
    Whenever::CommandLine.execute block: mount_schedule, clear: true, identifier: 'boxafe-mount'
  end

  private

  def self.mount_schedule
    Proc.new do
      every 1.minute do
        command 'echo $(date) > /Users/unknow/Projects/boxafe/bar.txt'
      end
    end
  end
end
