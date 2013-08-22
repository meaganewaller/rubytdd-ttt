require 'spec_helper'
require 'console'
require 'input_output'
require 'view'

describe Console do
  before :all do
    @input = StringIO.new('', 'r+')
    @output = StringIO.new('', 'w')
    @players = [:player1, :player2]
    @player_markers = { :player1 => :PLAYER1, :player2 => :PLAYER2 }
  end

  before :each do
    @input.reopen('', 'r+')
    @output.reopen('', 'w')
    @console = Console.new(@input, @output)
    @io = @console.io
    @view = @console.view
  end

  describe "#set_markers" do
    it "has io send output" do
      @console.should_receive(:get_player_marks).and_return('X')
      @console.set_markers(@player_markers)
    end

    it "assigns markers to players" do
      @console.stub(:get_player_marks).and_return('X')
      @console.set_markers(@player_markers)
      @console.markers[:player1].should == 'X'
      @console.markers[:player2].should == 'O'
    end
  end

  it "receives command-line input to get player space" do
    @input.reopen('2', 'r+')
    @console.get_player_space.should == 1
  end

  it "lets user quit at anytime" do
    lambda { @console.quit_game_anytime; exit }.should raise_error SystemExit
  end


  context "asking user if they want to play again" do
    it "exits the game if user says no" do
      @output.should_receive(:print).exactly(3).times
      @input.should_receive(:gets).and_return("X", "2", "e")
      @console.play_again.should == 0
    end

    it "lets user restart game with their current settings" do
      @output.should_receive(:print).exactly(3).times
      @input.should_receive(:gets).and_return("q", "4", "r")
      @console.play_again.should == 1
    end

    it "lets users start up a new game" do
      @output.should_receive(:print).exactly(3).times
      @input.should_receive(:gets).and_return("f", "t", "s")
      @console.play_again.should == 2
    end
  end

  it "asks user to pick a mark" do
    @output.should_receive(:print).exactly(4).times
    @input.should_receive(:gets).and_return('f', 'a', 'x', 'X')
    @console.get_player_marks.should == 'X'
  end

  describe "asking user to pick opponent" do
    before :each do
      @opponent_types = [:human, :computer]
    end

    it "accepts valid input" do
      @input.reopen('1', 'r')
      @console.get_opponent_type(@opponent_types).should == :human
    end

    it "keeps asking until input is valid" do
      @output.should_receive(:print).exactly(4).times
      @input.should_receive(:gets).and_return('0', '4', '3', '1')
      @console.get_opponent_type(@opponent_types).should == :human
    end
  end

  describe "#display_winner" do
    it "prints message of who the winner is" do
      @console.stub(:get_player_marks).and_return('X')
      @console.set_markers(@player_markers)
      @player_markers.keys.each do |marker|
        message = "Player #{@console.markers[marker]} is the winner"
        @console.out.should_receive(:puts).with("", message)
        @console.display_winner(marker)
      end
    end
  end

  describe "#display_tied" do
    it "prints message for a tied game" do
      message = "Tied game"
      @console.out.should_receive(:puts).with("", message)
      @console.display_tied
    end
  end

  describe "#get_player_order" do
    it "gives first turn to X marker" do
      @console.stub(:get_player_marks).and_return('X')
      @console.set_markers({:player1 => :PLAYER1, :player2 => :PLAYER2})
      @console.get_player_order.should == [:player1, :player2]
      @console.stub(:get_player_marks).and_return('O')
      @console.set_markers({:player1 => :PLAYER1, :player2 => :PLAYER2})
      @console.get_player_order.should == [:player2, :player1]
    end
  end

  describe "#display_board" do
    before :each do
      @board = double("Board").as_null_object
      @view.stub(:board_for_view).and_return(["_|_|_", "X|O|_", "_|X|O"])
    end

    it "converts board for view on command line" do
      @view.should_receive(:board_for_view)
      @console.display_board(@board)
    end

    it "displays board" do
      expected = ["     _|_|_","     X|O|_","     _|X|O"]
      @output.should_receive(:puts).with("", *expected)
      @console.display_board(@board)
    end
  end

  describe "#display_board_available_spaces" do
    before :each do
      @board = double("Board").as_null_object
      board_expected = ["_|_|_", "X|_|O", "O|X|_"]
      available_expected = ["1 2 3", " 4  ", "    8"]
      @view.stub(:board_for_view).and_return(board_expected)
      @view.stub(:available_spaces_for_view).and_return(available_expected)
    end

    it "shows available spaces for user" do
      @view.should_receive(:available_spaces_for_view)
      @console.display_board_available_spaces(@board)
    end

    it "displays board with available spaces" do
      expected = [ "     _|_|_     1 2 3",
        "     X|_|O       4  ",
        "     O|X|_         8"]
      @output.should_receive(:puts).with("", *expected)
      @console.display_board_available_spaces(@board)
    end
  end
end
