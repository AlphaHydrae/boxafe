# encoding: UTF-8
require 'fileutils'

class Boxafe::Encfs

  def initialize options = {}
    @options = options
  end

  def command
    [
      encfs_config,
      Shellwords.escape(@options[:encfs]),
      Shellwords.escape(absolute_root_dir),
      Shellwords.escape(absolute_mount_dir),
      extpass,
      '--',
      volname
    ].compact.join ' '
  end

  private

  def absolute_root_dir
    # TODO: remove Dir.pwd once fakefs is fixed (multiple occurrences in this file)
    File.expand_path @options[:root], Dir.pwd
  end

  def absolute_mount_dir
    File.expand_path @options[:mount], Dir.pwd
  end

  def volname
    %/-ovolname=#{Shellwords.escape @options[:volume]}/
  end

  def extpass
    if @options[:password_file]
      %|--extpass="head -n 1 #{Shellwords.escape @options[:password_file]}"|
    elsif @options[:keychain]
      %*--extpass="security 2>&1 >/dev/null find-generic-password -gl '#{@options[:keychain]}' |grep password|cut -d \\\\\\" -f 2"*
    else
      nil
    end
  end

  def encfs_config
    @options[:encfs_config] ? %/ENCFS6_CONFIG=#{Shellwords.escape File.expand_path(@options[:encfs_config], Dir.pwd)}/ : nil
  end
end
