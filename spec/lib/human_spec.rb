require 'spec_helper'
require 'human'

describe Human do
  before :each do
    @console = double("console").as_null_object
    @board = double("board").as_null_object
    @player = Human.new
    @player.console = @console
  end

  describe "#place_mark" do
    it "gets mark info from the console" do
      @console.should_receive("get_player_space").and_return(5)
      @player.make_move(@board)
    end

    it "checks for valid mark" do
      @console.stub(:get_player_space).and_return(0, 6)
      @board.should_receive(:is_space_available?).and_return(false, true)
      @player.make_move(@board).should == 6
    end
  end

  describe "#to_s" do
    it "converts to class" do
      Human.to_s.should == "Human"
    end
  end
end
