require 'board'
require 'ai'

class UnbeatableComputer
  attr_accessor :console
  attr_reader :ai

  def initialize(opponent)
    @ai = AI.new
    @ai.max = self
  end

  def self.to_s
    "Unbeatable Computer"
  end

  def get_opponent_mark(board)
    opponent_mark = (board.markers_added - [self]).first 
    opponent_mark.nil? ? :opponent : :opponent_mark
  end
end
