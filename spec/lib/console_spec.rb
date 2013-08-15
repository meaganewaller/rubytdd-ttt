require 'spec_helper'
require 'console'
require 'input_output'
require 'view'

describe Console do
  before :all do
    @input = StringIO.new('', 'r+')
    @output = StringIO.new('', 'w')
    @io = InputOutput.new
    @io.setup(@input, @output)
    @view = View.new
    @view.output(@output)
    @players = [:player1, :player2]
  end

  before :each do
    @console = Console.new(@io, @view)
    @console.set_players_markers(@players)
    @console.out = @output
  end

  describe "#new" do
    it "assigns blank marks to blank spaces" do
      @console.marker[Board::BLANK].should == "_"
    end
  end

  describe "#set_players_markers" do
    it "sets markers for players" do
      @console.marker[:player1].should == "X"
      @console.marker[:player2].should == "O"
    end
  end

  describe "#get_player_mark" do
    it "gets input from command line" do
      @input.reopen('2', 'r+')
      @console.get_player_mark.should == 1
    end
  end

  describe "#play_again?" do
    it "asks the user to play again" do
      @output.should_receive(:print).twice
      @input.should_receive(:gets).and_return('l', 'y')
      @console.play_again?.should be_true
    end
  end

  describe "#pick_marker" do
    it "lets user pick their marker" do
      @output.should_receive(:print).exactly(4).times
      @input.should_receive(:gets).and_return('p', 'r', 't', 'X')
      @console.pick_marker.should == "X"
    end
  end


  describe "#prompt_opponent_type" do
    before :each do 
      @opponent_types = [:human, :computer]
    end
    
    it "accepts valid input" do
      @input.reopen('1', 'r')
      @console.prompt_opponent_type(@opponent_types).should == :human
    end

    it "keeps asking until valid input" do
      @output.should_receive(:print).twice
      @input.should_receive(:gets).and_return('0', '1')
      @console.prompt_opponent_type(@opponent_types).should == :human
    end
  end

  describe "#get_marks" do
    it "assigns 'X' and 'O' to players" do
      given = { :player1 => nil, :player2 => nil }
      expected = {:player1 => 'X', :player2 => 'O' }
      @input.stub(:gets).and_return('X')
      @console.get_marks(given).should == expected
  end
  end
end
