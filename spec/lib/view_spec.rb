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

  it "has reference to the output" do
    @view.set_output($stdout)
  end

  it "converts board for view on commandline" do
    test_make_moves([1,2], :player)
    test_make_moves([5,8], :opponent)
    test_markers = {Board::BLANK => "_", :player => "X", :opponent => "O" }
    expected = ["_|X|X", "_|_|O", "_|_|O"]
    @view.board_for_view(@board, test_markers).should == expected
  end

  it "converts available spaces for view on commandline" do
    test_make_moves([4,5], :player)
    test_make_moves([3,6], :opponent)
    expected = ["1 2 3", "     ", "  8 9"]
    @view.available_spaces_for_view(@board).should == expected
  end

  it "has list of available opponents" do
    expected = "1: Human, 2: Easy Computer, 3: Unbeatable Computer"
    @view.player_opponent_list(["Human", "Easy Computer", "Unbeatable Computer"]).should == expected
  end

  private
  def test_make_moves(spaces, mark)
    spaces.each do |space|
      @board.make_move(space, mark)
    end
  end
end
