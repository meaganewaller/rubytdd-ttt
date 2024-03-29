require 'spec_helper'
require 'board'

describe Board do
  before :each do
    @board_size = 3
    @board = Board.new(@board_size)
  end

  describe "#new" do
    it "has a size" do
      @board.size.should == @board_size
    end

    it "has spaces equal to size squared" do
      @board.spaces.length.should == 9
    end

    it "has blank spaces" do
      @board.spaces.should == [Board::BLANK] * @board_size ** 2
    end

    it "has winning solutions for size 3 board" do
      @board.solutions.should == [
        [0,1,2],[3,4,5],[6,7,8],
        [0,3,6],[1,4,7],[2,5,8],
        [0,4,8],[2,4,6]
      ]
    end
  end


  describe "#make_move" do
    it "accepts marks" do
      @board.make_move(0, :player1)
      @board.spaces[0].should == :player1
    end
  end

  describe "#is_space_available" do
    it "returns true if space is unmarked" do
      @board.is_space_available?(0).should be_true
    end

    it "returns false if space is invalid" do
      @board.is_space_available?(-10).should be_false
      @board.is_space_available?(11).should be_false
    end

    it "returns false is space is marked" do
      @board.make_move(0, :player)
      @board.is_space_available?(0).should be_false
    end
  end

  describe "#spaces_taken_by_player" do
    it "has all the spaces a specific marker is in" do
      test_make_move([0,1,6,8], :player1)
      @board.spaces_taken_by_player(:player1).should == [0,1,6,8]
    end

    it "has all the spaces a blank marker is in" do
      @board.spaces_taken_by_player(Board::BLANK).should == (0..8).to_a
    end
  end

  describe "#reset_board" do
    it "resets each space back to BLANK" do
      test_make_move([3,4,5,6,7,8], :player)
      @board.reset_board
      @board.spaces_taken_by_player(:player).should == []
      @board.spaces_taken_by_player(Board::BLANK).should == (0..8).to_a
    end

    it "initialize empty" do
      @board.markers_added.should == []
    end

    it "stores player markers add to board" do
      test_make_move([0,1], :player1)
      test_make_move([2], :player2)
      @board.markers_added.should == [:player1, :player2]
    end
  end

  describe "winner?" do
    it "knows when there isn't a winner" do
      @board.winner?(:anything).should be_false
    end

    it "returns true when there is a winner" do
      test_spaces = @board.solutions.flatten
      test_make_move(test_spaces, :player1)
      @board.winner?(:player1).should be_true
    end

    it "knows when there isnt a winner because the board is full" do
      test_make_move([0,1,5,6,8], :player1)
      test_make_move([2,3,4,7], :player2)
      @board.winner?(:player1, :player2).should be_false
    end
  end

  private
  def test_make_move(spaces, mark)
    spaces.each do |space|
      @board.make_move(space, mark)
    end
  end
end
