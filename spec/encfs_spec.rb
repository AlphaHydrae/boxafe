require 'helper'

describe Boxafe::Encfs do

  let(:encfs_options){ { encfs: 'encfs', root: '/encrypted', mount: '/clear', volume: 'Boxafe' } }

  it "should generate an encfs command" do
    expect_command.to eq('encfs /encrypted /clear -- -ovolname=Boxafe')
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

  it "should load the password from the keychain whith the keychain option" do
    expect_command(keychain: 'foo').to eq('encfs /encrypted /clear --extpass="security 2>&1 >/dev/null find-generic-password -gl \'foo\' |grep password|cut -d \\\\\\" -f 2" -- -ovolname=Boxafe')
  end

  it "should load the password from a file with the password_file options" do
    expect_command(password_file: '/tmp/password').to eq('encfs /encrypted /clear --extpass="head -n 1 /tmp/password" -- -ovolname=Boxafe')
  end

  it "should escape options containing spaces" do
    expect_command(encfs: '/bin/enc fs', root: '/en crypted', mount: '/cl ear', encfs_config: '/.en cfs.xml').to eq('ENCFS6_CONFIG=/.en\ cfs.xml /bin/enc\ fs /en\ crypted /cl\ ear -- -ovolname=Boxafe')
  end

  def expect_command options = {}
    expect Boxafe::Encfs.new(encfs_options.merge(options)).command
  end
end
