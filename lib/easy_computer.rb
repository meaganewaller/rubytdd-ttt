require 'board'
class EasyComputer
  attr_accessor :console, :mark

  def make_move(board)
    board.spaces_taken_by_player(Board::BLANK).sample
  end

  def self.to_s
    "Easy Computer"
  end
end
