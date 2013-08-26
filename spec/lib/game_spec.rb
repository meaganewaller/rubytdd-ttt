require 'spec_helper'
require 'game'
require 'setup'

describe Game do
  before :each do
    @console = double("console").as_null_object
    @setup = SetUp.new(@console)
    @player1 = double("player").as_null_object
    @player2 = double("player").as_null_object
    @setup.stub(:players).and_return([@player1, @player2])
    @game = Game.new(@setup)
    @board = @game.board = double("Board").as_null_object
  end

  context "new game" do
    it "return false for #over?" do
      @game.board.should_receive(:winner?).and_return(false)
      @game.board.should_receive(:taken_by_marker).and_return([nil]*9)
      @game.over?.should be_false
    end

    it "clones player list from setup" do
      @setup.stub(:players).and_return([@player1, @player2])
      @game = Game.new(@setup)
      @game.players.should == [@player1, @player2]
    end

    it "has Board object" do
      @game.board.should_not be_nil
    end
  end

  context "while playing" do
    it "has console display board and available spaces" do
      @board.stub(:winner?).and_return(false, true)
      @board.stub(:taken_by_marker).and_return([nil]*9)
      @console.should_receive(:display_board_available_spaces)
      @game.play
    end

    it "gets moves from player" do
      @board.stub(:winner?).and_return(false, true)
      @board.stub(:taken_by_marker).and_return([nil]*9)
      @player1.should_receive(:make_move)
      @game.play
    end

    it "keeps getting mark until game over" do
      @board.stub(:winner?).and_return(false, false, false, false, false, false, true)
      @board.stub(:taken_by_marker).and_return([nil]*9)
      @player1.should_receive(:make_move).exactly(3).times
      @player2.should_receive(:make_move).exactly(3).times
      @game.play
    end

    it "switches players" do
      players = [@player1, @player2]
      @board.stub(:winner?).and_return(false, false, false, false, true)
      @board.stub(:taken_by_marker).and_return([nil]*9)
      @marks = []
      players.each { |each| each.should_receive(:make_move).twice {
        @marks << @game.players.first
      }}
      @game.play
      @marks.should == @game.players*2
    end
  end

  context "when game over" do
    it "ends when winner" do
      @board.stub(:winner?).and_return(true)
      @board.stub(:taken_by_marker).and_return([nil]*9)
      @game.over?.should be_true
    end

    it "ends when the board is full" do
      @board.should_receive(:winner?).and_return(false)
      @board.should_receive(:taken_by_marker).and_return([])
      @game.over?.should be_true
    end

    it "displays game winner if there is one" do
      @console.should_receive(:display_winner)
      @console.should_not_receive(:display_tied)
      @board.stub(:winner?).and_return(true)
      @game.play
    end
  end
end
