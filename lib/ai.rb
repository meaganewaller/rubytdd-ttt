class AI
  attr_accessor :min_player, :max_player

  def initialize(min_player, max_player)
    @min_player = min_player
    @max_player = max_player
  end

  def score(board, current_player)
    score = 0
    score = 1 if board.winner?(@max_player)
    score = -1 if board.winner?(@min_player)
    score
  end
end
