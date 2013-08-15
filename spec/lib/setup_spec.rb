require 'spec_helper'
require 'human'
require 'easy_computer'
require 'unbeatable_computer'
require 'setup'

describe SetUp do
  before :each do
    @console = double("Console").as_null_object
    @setup = SetUp.new(@console)
  end

  describe "#new" do
    it "has console object" do
      @setup.console.should == @console
    end

    it "has no players" do
      @setup.players.should == []
    end

    it "has empty 'player_marks' hash" do
      @setup.player_marks.should == {}
    end
  end

  describe "PLAYER_LIST" do
    it "has a list of available 'Players'" do
      SetUp::PLAYER_LIST.should == [Human, EasyComputer, UnbeatableComputer]
    end
  end

  describe "#pick_opponent" do
    it "uses console to prompt opponent from playerlist" do
     @opponent =  double("Player").as_null_object
     @console.should_receive(:prompt_opponent_type).with(SetUp::PLAYER_LIST).and_return(@opponent)
     @setup.pick_opponent
    end

    it "stores instance of opponent pick" do
      @opponent = double("Player").as_null_object
      @console.stub(:prompt_opponent_type).and_return(@opponent)
      @opponent.should_receive(:new).and_return(@opponent)
      @setup.pick_opponent
      @setup.players.last.should == @opponent
    end
  end

  describe "#pick_player" do
    it "has instance of Human stored" do
      @setup.pick_player
      @setup.players.first.should be_instance_of(Human)
    end
  end

  describe ".player_marks" do
    before :each do
      @opponent = double("Player").as_null_object
      @console.stub(:prompt_opponent_type).and_return(@opponent)
      @opponent.stub(:new).and_return(@opponent)
      @setup.pick_player
      @setup.pick_opponent
      @setup.assign_mark
    end

    it "assigns mark by player index" do
      @setup.player_marks[:player0].should == @setup.players[0]
      @setup.player_marks[:player1].should == @setup.players[1]
    end

    it "assigns unique marks" do
      @setup.players.each do |player|
        @setup.player_marks.should have_value(player)
      end
    end
  end
end
