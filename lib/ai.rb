require 'board'
class AI

  MAX_VALUE = 1
  MIN_VALUE = -1
  DEFAULT_DEPTH = 9

  attr_accessor :min_player, :max_player, :depth_limit
  attr_reader :current_depth

  def initialize
    @depth_limit = DEFAULT_DEPTH
    @current_depth = 0
  end

  def assign_scores_to_moves(board, current_player)
    scores = score_storage(board, current_player)
    scores.inject({}) do |result, (key, value)|
      result[key] = value || 0
      result
    end
  end

  def score_storage(board, current_player)
    scores = Hash.new
    current_board = board.dup
    current_board.spaces_taken_by_player(Board::BLANK).each do |space|
      current_board.make_move(space, current_player)
      scores[space] = find_score(current_board, current_player)
      current_board.make_move(space, Board::BLANK)
      break if scores[space] == best_score(current_player)
    end
    scores
  end

  def find_score(board, current_player)
    final_score = win_score(board)
    if final_score.nil? && @current_depth < @depth_limit
      @current_depth += 1
      next_player = find_opponent(current_player)
      scores_of_spaces = score_storage(board, next_player)
      if scores_of_spaces.has_value?(best_score(next_player))
        final_score = best_score(next_player)
      elsif scores_of_spaces.has_value?(nil)
        final_score = nil
      else
        final_score = assign_min_or_max(next_player, scores_of_spaces.values)
      end
      @current_depth -= 1
    end
    final_score
  end

  def find_opponent(current_player)
    current_player == @max_player ? @min_player : @max_player
  end

  def assign_min_or_max(next_player, space_scores)
    return space_scores.max if next_player.eql?(@max_player)
    space_scores.min
  end

  def win_score(board)
    score = nil
    score = MAX_VALUE if board.winner?(@max_player)
    score = MIN_VALUE if board.winner?(@min_player)
    score
  end

  def best_score(current_mark)
    current_mark.eql?(@max_player) ? MAX_VALUE : MIN_VALUE
  end
end
