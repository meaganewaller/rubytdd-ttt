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

  def score_moves(board, current_player)
    map = score_storage(board, current_player)
    map.inject({}) { |result, (key, value) |
      result[key] = value.nil? ? 0 : value
      result
    }
  end

  def score_storage(board, current_player)
    scores = Hash.new
    current_board = board.dup
    current_board.taken_by_marker(Board::BLANK).each do |space|
      current_board.place_mark(space, current_player)
      scores[space] = score(current_board, current_player)
      current_board.place_mark(space, Board::BLANK)
      break if scores[space] == best_score(current_player)
    end
    scores
  end

  def score(board, current_player)
    score = win_score(board)
    if score.nil? && @current_depth < @depth_limit
      @current_depth += 1
      next_player = opponent(current_player)
      space_scores = score_storage(board, next_player)
      if space_scores.has_value?(best_score(next_player))
        score = best_score(next_player)
      elsif space_scores.has_value?(nil)
        score = nil
      else
        score = assign_min_or_max(next_player, space_scores.values)
      end
      @current_depth -= 1
    end
    score
  end

  def opponent(current_player)
    current_player == @max_player ? @min_player : @max_player
  end

  def assign_min_or_max(next_player, space_scores)
    if next_player.eql?(@max_player)
      space_scores.max
    else
      space_scores.min
    end
  end

  def win_score(board)
    score = nil
    return MAX_VALUE if board.winner?(@max_player)
    return MIN_VALUE if board.winner?(@min_player)
    return score
  end

  def best_score(current_mark)
    current_mark.eql?(@max_player) ? MAX_VALUE : MIN_VALUE
  end
end
