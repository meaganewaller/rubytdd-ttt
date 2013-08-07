require 'ttt'

describe TicTacToe do
  describe "#prompt_opponent_type" do
    it "allows player to play against a human" do
      ttt = TicTacToe.new
      $stdin = StringIO.new('h', 'r')
      ttt.prompt_opponent_type.should == :human
    end
  end
end
