require 'helper'

describe Boxafe::Encfs do

  let(:options){ { encfs: 'encfs', root: '/encrypted', mount: '/clear', volume: 'Boxafe' } }
  subject{ Boxafe::Encfs.new options }

  its(:command){ should eq('encfs "/encrypted" "/clear" -- -ovolname="Boxafe"') }

  context "with a custom binary" do
    let(:options){ super().merge encfs: '/usr/local/bin/encfs' }
    its(:command){ should eq('/usr/local/bin/encfs "/encrypted" "/clear" -- -ovolname="Boxafe"') }
  end

  context "with an encfs config" do
    let(:options){ super().merge encfs_config: '/.encfs.xml' }
    its(:command){ should eq('ENCFS6_CONFIG="/.encfs.xml" encfs "/encrypted" "/clear" -- -ovolname="Boxafe"') }
  end
end
