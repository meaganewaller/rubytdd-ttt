require 'board'
require 'ai'

class UnbeatableComputer
  attr_accessor :console, :mark
  attr_reader :ai

  def initialize
    @ai = AI.new
  end

  def self.to_s
    "Unbeatable Computer"
  end

  def place_mark(board)
    @ai.depth_limit = 9
    @ai.min_player = get_opponent_mark(board)
    @ai.max_player = @mark
    space_scores = @ai.score_moves(board, @mark)
    space_scores.sort_by { |space, score| score}.last[0]
  end

  def get_opponent_mark(board)
    opponent_mark = (board.markers_added - [@mark]).first
    opponent_mark.nil? ? :opponent : opponent_mark
  end
end
