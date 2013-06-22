require 'launchdr'
require 'fileutils'

class Boxafe::Scheduler::Launchd < Boxafe::Scheduler

  def start
    stop
    plist.dump USER_AGENT
    plist.load!
  end

  def stop
    return false unless plist_exists?
    plist.unload!
    FileUtils.rm_f plist.file
  end

  private

  LABEL = 'com.alphahydrae.boxafe'
  USER_AGENT = LaunchDr::Launchd::Paths[:user_agent]

  def plist_exists?
    begin
      File.exists? plist.file
    rescue
      false
    end
  end

  def plist
    @plist ||= LaunchDr::Launchd.new(LABEL).tap do |plist|
      plist[:ProgramArguments] = [ 'boxafe', 'mount' ]
      plist[:RunAtLoad] = true
      plist[:EnvironmentVariables] = { 'PATH' => ENV['PATH'] } # TODO: add path option
    end
  end
end
