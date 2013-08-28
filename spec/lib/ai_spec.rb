require 'spec_helper'
require 'ai'
require 'board'

describe AI do
  before :each do
    @ai = AI.new
    @ai.max_player = :max_player
    @ai.min_player = :min_player
    @board = Board.new
  end

  it "sets current depth to 0" do
    @ai.current_depth.should == 0
  end

  it "returns 1 for a max winning move" do
    test_make_moves([0,1,2], :max_player)
    @ai.find_score(@board, :max_player).should == 1
  end

  it "returns -1 for a min winning move" do
    test_make_moves([0,1,2], :min_player)
    @ai.find_score(@board, :max_player).should == -1
  end

  it "has spaces with find_scores" do
    test_make_moves([0, 3, 7], :max_player)
    test_make_moves([1, 2, 5], :min_player)
    expected = {4 => -1, 6 => 1}
    @ai.assign_scores_to_moves(@board, :max_player).should == expected
  end

  it "stops scoring when best find_score is found" do
    test_make_moves([0, 3, 7], :min_player)
    test_make_moves([2, 4], :max_player)
    expected = {1 => -1, 5 => -1, 6 => 1}
    @ai.assign_scores_to_moves(@board, :max_player).should == expected
  end

  context "depth limits" do
    before :each do
      @board = Board.new
      test_make_moves([0], :max_player)
      test_make_moves([4, 5], :min_player)
    end

    it "gets correct find_score with depth limit of zero" do
      expected_scores = { 1 => 0, 2 => 0, 3 => 0, 6 => 0, 7 => 0, 8 => 0 }
      @ai.depth_limit = 0
      @ai.assign_scores_to_moves(@board, :max_player).should == expected_scores
    end

    it "gets correct find_score with depth limit of one" do
      expected_scores = { 1=> -1, 2 => -1, 3 => 0, 6 => -1, 7 => -1, 8 => -1 }
      @ai.depth_limit = 1
      @ai.assign_scores_to_moves(@board, :max_player).should == expected_scores
    end
  end

  private
  def test_make_moves(spaces, mark)
    spaces.each do |space|
      @board.make_move(space, mark)
    end
  end
end
