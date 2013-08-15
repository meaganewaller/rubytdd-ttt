require 'spec_helper'
require 'board'
require 'unbeatable_computer'

describe UnbeatableComputer do
  before :all do
    @opponent = :player
    @cpu = UnbeatableComputer.new(@opponent)
  end

  before :each do
    @board = Board.new
  end
  
  it "converts to string" do
    UnbeatableComputer.to_s.should == "Unbeatable Computer"
  end

  it "has reference to console" do
    @cpu.console = double("console")
  end

  it "can make marks on the AI object" do
    @cpu.ai.should be_instance_of(AI)
    @cpu.ai.max.should == @cpu
  end

  it "has an an opponent" do
    @cpu.get_opponent_mark(@board).should == :opponent
  end


  def test_place_marks(spaces, mark)
    spaces.each {|space|
      @board.place_mark(space, mark)
    }
  end
end
