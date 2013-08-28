require 'spec_helper'
require 'easy_computer'

TIMES = 50
describe EasyComputer do
  before :all do
    @computer = EasyComputer.new
  end

  before :each do
    @board = Board.new
  end

  it "chooses random move" do
    @board.stub(:spaces_taken_by_player).and_return((0..8).to_a)
    marks = []
    TIMES.times do
      marks << @computer.make_move(@board)
    end
    marks.uniq.sort.should == (0..8).to_a
  end

  it "only makes valid spaces" do
    @board.stub(:spaces_taken_by_player).and_return((1..4).to_a)
    marks = []
    TIMES.times do
      marks << @computer.make_move(@board)
    end
    marks.uniq.sort.should == (1..4).to_a
  end

  it "converts to string" do
    EasyComputer.to_s.should == "Easy Computer"
  end

  it "has reference to console" do
    @computer.respond_to?(:console).should be_true
  end
end
