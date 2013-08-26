require 'spec_helper'
require 'unbeatable_computer'

describe UnbeatableComputer do
  before :all do
    @opponent = :player
    @cpu = UnbeatableComputer.new
    @cpu.mark = :cpu
  end

  before :each do
    @board = Board.new
    @edges = [1,3,5,7]
  end

  it "has reference to AI" do
    @cpu.ai.should be_instance_of(AI)
  end

  it "converts to string" do
    UnbeatableComputer.to_s.should == "Unbeatable Computer"
  end

  it "has default opponent" do
    @cpu.get_opponent_mark(@board).should == :opponent
  end

  it "returns opposite symbol for opponent" do
    @board.make_move(0, :player2)
    @cpu.get_opponent_mark(@board).should == :player2
  end

  it "sets min_player to default value" do
    @cpu.ai.stub(:score_storage).and_return([1])
    @cpu.make_move(@board)
    @cpu.ai.min_player.should == :opponent
  end

  it "sets max_player to mark" do
    @cpu.mark = :anything
    @cpu.ai.stub(:score_storage).and_return([1])
    @cpu.make_move(@board)
    @cpu.ai.max_player.should == @cpu.mark
  end

  it "has reference to console" do
    @cpu.respond_to?(:console).should be_true
  end

  it "picks winning space" do
    [0, 4, 6].each { |space| @board.make_move(space, @cpu.mark) }
    [2, 5, 7].each { |space| @board.make_move(space, @opponent) }
    @cpu.make_move(@board).should == 3
  end

  describe "with one space left" do
    it "takes last open space" do
      [0, 2, 4, 7].each { |space| @board.make_move(space, @opponent) }
      [1, 3, 6, 8].each { |space| @board.make_move(space, @cpu.mark) }
      @cpu.make_move(@board).should == 5
    end
  end

  describe "with two spaces left" do
    it "picks winning space" do
      [0, 2, 3, 5].each { |space| @board.make_move(space, @opponent)}
      [1, 4, 6].each { |space| @board.make_move(space, @cpu.mark) }
      @cpu.make_move(@board).should == 7
    end

    it "can block a winning move" do
      [0, 5, 6, 8].each { |space| @board.make_move(space, @opponent)}
      [2, 3, 4].each { |space| @board.make_move(space, @cpu.mark) }
      @cpu.make_move(@board) == 7
    end
  end

  describe "three spaces left" do
    it "picks a winning space" do
      [0, 2, 3].each { |space| @board.make_move(space, @opponent)}
      [1, 4, 5].each { |space| @board.make_move(space, @cpu.mark) }
      @cpu.make_move(@board).should == 7
    end

    it "can block a move" do
      [0, 4, 7].each { |space| @board.make_move(space, @opponent)}
      [1, 3, 6].each { |space| @board.make_move(space, @cpu.mark)}
      @cpu.make_move(@board).should == 8
    end
  end

  it "has mark assigned to it" do
    @cpu.mark = :anything
  end
end
