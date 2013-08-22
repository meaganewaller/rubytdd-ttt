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
    test_place_marks([0,1,2], :max_player)
    @ai.score(@board, :max_player).should == 1
  end

  it "returns -1 for a min winning move" do
    test_place_marks([0,1,2], :min_player)
    @ai.score(@board, :max_player).should == -1
  end

  it "has spaces with scores" do
    test_place_marks([0, 3, 7], :max_player)
    test_place_marks([1, 2, 5], :min_player)
    expected = {4 => -1, 6 => 1}
    @ai.score_moves(@board, :max_player).should == expected
  end

  it "stops scoring when best score is found" do
    test_place_marks([0, 3, 7], :min_player)
    test_place_marks([2, 4], :max_player)
    expected = {1 => -1, 5 => -1, 6 => 1}
    @ai.score_moves(@board, :max_player).should == expected
  end

  context "depth limits" do
    before :each do
      @board = Board.new
      test_place_marks([0], :max_player)
      test_place_marks([4, 5], :min_player)
    end

    it "gets correct score with depth limit of zero" do
      expected_scores = { 1 => 0, 2 => 0, 3 => 0, 6 => 0, 7 => 0, 8 => 0 }
      @ai.depth_limit = 0
      @ai.score_moves(@board, :max_player).should == expected_scores
    end

    it "gets correct score with depth limit of one" do
      expected_scores = { 1=> -1, 2 => -1, 3 => 0, 6 => -1, 7 => -1, 8 => -1 }
      @ai.depth_limit = 1
      @ai.score_moves(@board, :max_player).should == expected_scores
    end

    it "gets correct score with depth limit of two" do
      expected_scores = { 1 => -1, 2 => -1, 3 => 0, 6 => -1, 7 => -1, 8 => -1 }
      @ai.depth_limit = 2
      @ai.score_moves(@board, :max_player).should == expected_scores
    end

    it "gets correct score with depth limit of three" do
      expected_scores = { 1 => -1, 2 => -1, 3 => 0, 6 => -1, 7 => -1, 8 => -1 }
      @ai.depth_limit = 3
      @ai.score_moves(@board, :max_player).should == expected_scores
    end

    it "gets correct score with depth limit of four" do
      expected_scores = { 1 => -1, 2 => -1, 3 => 0, 6 => -1, 7 => -1, 8 => -1 }
      @ai.depth_limit = 4
      @ai.score_moves(@board, :max_player).should == expected_scores
    end

    it "gets correct score with depth limit of five" do
      expected_scores = { 1 => -1, 2 => -1, 3 => 0, 6 => -1, 7 => -1, 8 => -1 }
      @ai.depth_limit = 5
      @ai.score_moves(@board, :max_player).should == expected_scores
    end
  end

  private
  def test_place_marks(spaces, mark)
    spaces.each do |space|
      @board.place_mark(space, mark)
    end
  end
end
