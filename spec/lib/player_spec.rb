require 'spec_helper'
require 'player'

describe Player do
  it "stores the marker" do
    @player = Player.new(:anything)
    @player.marker.should == :anything
  end
end
