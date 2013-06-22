require 'fileutils'

class Boxafe::Encfs

  def initialize options = {}
    @options = options
  end

  def command
    [ encfs_config, @options[:encfs], @options[:root], @options[:mount], extpass, '--', volname ].compact.join ' '
  end

  private

  def volname
    "-ovolname=#{@options[:volume]}"
  end

  def extpass
    if @options[:keychain]
      %*--extpass="security 2>&1 >/dev/null find-generic-password -gl '#{@options[:keychain]}' |grep password|cut -d \\\\\\" -f 2"*
    else
      nil
    end
  end

  def encfs_config
    @options[:config] ? "ENCFS6_CONFIG=#{@options[:config]}" : nil
  end
end
