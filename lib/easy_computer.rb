require 'board'
class EasyComputer
  attr_accessor :console, :mark

  def place_mark(board)
    board.taken_by_marker(Board::BLANK).sample
  end

  def self.to_s
    "Easy Computer"
  end
end
