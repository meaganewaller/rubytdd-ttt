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
      @console.should_receive("get_player_mark").and_return(5)
      @player.place_mark(@board)
    end

    it "checks for valid mark" do
      @console.should_receive(:get_player_mark).and_return(0, 4)
      @board.should_receive(:place_mark).once
      @board.should_receive(:is_space_available?).and_return(false, true)
      @player.place_mark(@board)
    end
  end
end
