require 'helper'

describe "Version" do

  it "should be correct" do
    version_file = File.join File.dirname(__FILE__), '..', 'VERSION'
    Boxafe::VERSION.should == File.open(version_file, 'r').read
  end
end
