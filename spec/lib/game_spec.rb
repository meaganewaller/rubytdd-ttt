require 'spec_helper'
require 'game'
require 'board'
require 'human'

describe Game do
  before :each do
    @console = double("console").as_null_object
    @game = Game.new(@console)
    @game.board = double("Board").as_null_object
    @player1 = double("player").as_null_object 
    @player2 = double("player").as_null_object
    @console.stub(:play_again?) { false }
  end

  context "new game" do
    it "return false for #over?" do
      @game.board.should_receive(:winner?).and_return(false)
      @game.board.should_receive(:taken_by_marker).and_return([nil]*9)
      @game.over?.should be_false
    end

    it "has no players" do
      @game.players.should == []
    end

    it "has Board object" do
      @game.board.should_not be_nil
    end
  end

  context "creating players" do
    it "creates new player from player input" do
      @player2.should_receive(:new).and_return(@player2)
      @console.should_receive(:prompt_opponent_type).and_return(@player2)
      @game.play
      @game.players.last.should == @player2
    end

    it "has two players" do
      @console.should_receive(:prompt_opponent_type).and_return(Human)
      @game.play
      @game.players.length.should == 2
      @game.players.first.should_not == @game.players.last
    end

    it "assigns console to players" do
      @game.players.each { |player| player.console.should == @console }
    end

    it "gets rid of previous players" do
      @console.stub(:prompt_opponent_type).and_return(Human,EasyComputer)
      @game.set_players
      @game.set_players
      @game.players.length.should == 2
      @game.players.last.should be_instance_of(EasyComputer)
    end
  end


  context "playing the game" do
    before :each do
      test_set_human_player(@player1)
    end

    it "gets mark from the player" do
      turns_until_over?(1)
      @player1.should_receive(:place_mark)
      @game.play
    end

    it "gets marks from the player until over" do
      turns_until_over?(5)
      test_set_opponent(@player1)
      @player1.should_receive(:place_mark).exactly(5).times
      @game.play
    end

    it "switches players" do
      players = [@player1, @player2]
      turns_until_over?(6)
      test_set_opponent(@player2)
      @turns = []
      players.each { |player| player.should_receive(:place_mark).exactly(3).times {
        @turns << @game.players.first 
      }}
      @game.play
      @turns.should == @game.players*3
    end

    it "has console display the board" do
      turns_until_over?(1)
      @console.should_receive(:display_board)
      @game.play
    end
  end

  context "when there is a winner" do
    it "return true for over" do
      turns_until_over?(0)
      @game.over?.should be_true
    end
  end

  context "when there is a tie" do
    it "returns true for over?" do
      @game.board = double("board").as_null_object
      @game.board.stub(:winner?) { false }
      @game.board.stub(:taken_by_marker) { [] }
      @game.over?.should be_true
    end
  end

  context "when game is over" do
    it "displays the game results" do
      @game.board = double("board").as_null_object
      turns_until_over?(0)
      @console.should_receive(:display_game_results).once
      @game.play
    end

    it "ask users to play again" do
      @game.board.should_receive(:winner?).twice.and_return(true)
      @console.should_receive(:play_again?).and_return(true, false)
      @game.play
    end

    it "resets the board before playing again" do
      @game.board.stub(:winner?).and_return(true)
      @console.should_receive(:play_again?).and_return(false)
      @game.board.should_receive(:reset).once
      @game.play
    end
  end

  def turns_until_over?(turns = 0)
    over = [false]*turns + [true]
    @game.board.should_receive(:winner?).and_return(*over)
    @game.board.stub(:taken_by_marker) { ([nil]*9) }
  end

  def test_set_players(*players)
    @players = players
    @game.players = @players
  end

  def test_set_opponent(player)
    @console.stub(:prompt_opponent_type).and_return(player)
    player.stub(:new).and_return(player)
  end

  def test_set_human_player(player)
    @game.player_types[0] = player
    player.stub(:new).and_return(player)
  end
end
