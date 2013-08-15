require 'spec_helper'
require 'board'
require 'view'

describe View do
  before :all do
    @view = View.new
  end

  before :each do
    @board = Board.new
  end

  it "has reference to output" do
    @view.output($stdout)
  end

  it "converts board for display on command line" do
    @board = Board.new
    test_place_mark([0, 1], :player)
    test_place_mark([4, 6], :opponent)
    hash = { Board::BLANK => "_", :player => "X", :opponent => "O"}
    expected = ["X|X|_", "_|O|_", "O|_|_"]
    @view.board_rep_view(@board, hash).should == expected
  end

  it "converts available spaces for view" do
    test_place_mark([0,1], :player)
    test_place_mark([4,6], :opponent)
    expected = ["    3", "4   6", "  8 9"]
    @view.available_spaces_for_view(@board).should == expected 
  end

  it "has list of available players" do
    expected = "[1: Human, 2: Easy Computer]"
    @view.players_list(["Human", "Easy Computer"]).should == expected
  end
  
  def test_place_mark(spaces, mark)
    spaces.each { |space| @board.place_mark(space, mark)}
  end
end
