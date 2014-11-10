require 'helper'

describe Boxafe::Box do
  include FakeFS::SpecHelpers
  let(:box_options){ { name: 'Boxafe', encfs: 'encfs', root: '/encrypted', mount: '/clear', volume: 'Boxafe' } }
  let(:box){ new_box box_options }

  before :each do
    allow(Kernel).to receive(:system).and_return(nil)
    FileUtils.mkdir_p box_options[:root]

    @old_path = ENV['PATH']
    ENV['PATH'] = '/bin:/usr/sbin:/sbin:/usr/local/bin:/usr/local/sbin'
    FileUtils.mkdir_p '/usr/local/bin'
    %w(encfs umount).each do |bin|
      FileUtils.touch "/usr/local/bin/#{bin}"
      FileUtils.chmod 0755, "/usr/local/bin/#{bin}"
    end
  end

  after :each do
    ENV['PATH'] = @old_path
  end

  it "should raise an error when created if the name option is missing" do
    expect{ Boxafe::Box.new box_options.merge(name: nil) }.to raise_error(Boxafe::Error, "The :name option is required")
  end

  describe "#name" do
    it "should return the name option" do
      expect(new_box(box_options.merge(name: 'foo')).name).to eq('foo')
      expect(new_box(box_options.merge(name: 'bar')).name).to eq('bar')
    end
  end

  shared_examples_for "an encfs controller" do |action|

    before :each do
      allow(Boxafe::Encfs).to receive(:new).and_return(double(command: 'fooo'))
    end

    it "should create an encfs manager" do
      expect(Boxafe::Encfs).to receive(:new)
      perform action
    end

    def perform action
      subject.send action
    end
  end

  describe "#mount" do
    subject{ box }
    it_should_behave_like "an encfs controller", :mount
  end

  def new_box options = {}
    Boxafe::Box.new options
  end
end
