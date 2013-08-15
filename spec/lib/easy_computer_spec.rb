require 'spec_helper'
require 'easy_computer'

describe EasyComputer do
  before :all do
    @opponent = :player
    @easycpu = EasyComputer.new(@opponent)
  end

  it "has an opponent" do
    @easycpu.opponent.should == @opponent
  end

  it "has a reference to the console" do
    @easycpu.console = double("console")
  end

  context "making a move" do
    before :each do
      @board = double("board")
      @board.should_receive(:place_mark).exactly(50).times
      @marks = []
    end
    
    it "picks a random space" do
      @board.should_receive(:taken_by_marker).exactly(50).times.and_return((0..8).sort)
      50.times do
        @marks << @easycpu.place_mark(@board)
      end
      @marks.uniq.sort.should == (0..8).sort
    end

    it "only moves in available spaces" do
      @board.should_receive(:taken_by_marker).exactly(50).times.and_return((1..3).sort)
      50.times do
        @marks << @easycpu.place_mark(@board)
      end
      @marks.uniq.sort.should == (1..3).sort
    end
  end
end
