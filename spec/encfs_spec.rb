require 'helper'
require 'fileutils'

describe Boxafe::Encfs do
  include FakeFS::SpecHelpers
  let(:home){ File.expand_path '~' }
  let(:default_encfs_options){ { encfs: 'encfs', root: '/encrypted', mount: '/clear', volume: 'Boxafe' } }

  it "should generate an encfs command" do
    expect_command.to eq('encfs /encrypted /clear -- -ovolname=Boxafe')
  end

  it "should use the specified root directory" do
    expect_command(root: '/other/encrypted').to eq('encfs /other/encrypted /clear -- -ovolname=Boxafe')
  end

  it "should expand the root directory from the working directory" do
    go_to_cwd
    expect_command(root: 'relative/encrypted').to eq('encfs /cwd/relative/encrypted /clear -- -ovolname=Boxafe')
  end

  it "should use the specified mount directory" do
    expect_command(mount: '/other/clear').to eq('encfs /encrypted /other/clear -- -ovolname=Boxafe')
  end

  it "should expand the mount directory from the home folder" do
    go_to_cwd
    expect_command(mount: 'relative/clear').to eq('encfs /encrypted /cwd/relative/clear -- -ovolname=Boxafe')
  end

  it "should use the provided custom binary" do
    expect_command(encfs: '/usr/local/bin/encfs').to eq('/usr/local/bin/encfs /encrypted /clear -- -ovolname=Boxafe')
  end

  it "should use the provided volume name" do
    expect_command(volume: 'Foo').to eq('encfs /encrypted /clear -- -ovolname=Foo')
  end

  it "should load the specified config file" do
    expect_command(encfs_config: '/.encfs.xml').to eq('ENCFS6_CONFIG=/.encfs.xml encfs /encrypted /clear -- -ovolname=Boxafe')
  end

  it "should expand the config file path from the working directory" do
    go_to_cwd
    expect_command(encfs_config: 'relative/.encfs.xml').to eq('ENCFS6_CONFIG=/cwd/relative/.encfs.xml encfs /encrypted /clear -- -ovolname=Boxafe')
  end

  it "should load the password from the keychain whith the keychain option" do
    expect_command(keychain: 'foo').to eq('encfs /encrypted /clear --extpass="security 2>&1 >/dev/null find-generic-password -gl \'foo\' |grep password|cut -d \\\\\\" -f 2" -- -ovolname=Boxafe')
  end

  it "should load the password from a file with the password_file options" do
    expect_command(password_file: '/tmp/password').to eq('encfs /encrypted /clear --extpass="head -n 1 /tmp/password" -- -ovolname=Boxafe')
  end

  it "should expand the password file path from the working directory" do
    go_to_cwd
    expect_command(password_file: 'relative/password').to eq('encfs /encrypted /clear --extpass="head -n 1 /cwd/relative/password" -- -ovolname=Boxafe')
  end

  it "should escape options containing spaces" do
    expect_command(encfs: '/bin/enc fs', root: '/en crypted', mount: '/cl ear', encfs_config: '/.en cfs.xml').to eq('ENCFS6_CONFIG=/.en\ cfs.xml /bin/enc\ fs /en\ crypted /cl\ ear -- -ovolname=Boxafe')
  end

  def go_to_cwd
    FileUtils.mkdir_p '/cwd'
    Dir.chdir '/cwd'
  end

  def expect_command options = {}
    expect Boxafe::Encfs.new(default_encfs_options.merge(options)).command
  end
end
