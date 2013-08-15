require 'spec_helper'
require 'ai'
require 'board'

describe AI do
  before :each do
    @board = Board.new
    @ai = AI.new(:min_player, :max_player)
  end

  it "returns 0 for a non-winning move" do
    @ai.score(@board, :max_player).should == 0
  end

  it "returns 1 for a winning move" do
    test_place_marks([0,1,2], :max_player)
    @ai.score(@board, :max_player).should == 1
  end

  it "returns -1 for opponent losing move" do
    test_place_marks([0,1,2], :min_player)
    @ai.score(@board, :max_player).should == -1
  end

  private
  def test_place_marks(spaces, marker)
    spaces.each do |space|
      @board.place_mark(space, marker)
    end
  end
end
