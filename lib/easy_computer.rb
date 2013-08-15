require 'board'
class EasyComputer
  attr_accessor :console
  attr_reader :opponent

  def initialize(opponent)
    @opponent = opponent
  end

  def place_mark(board)
    space = board.taken_by_marker(Board::BLANK).sample
    board.place_mark(space, self)
    space
  end

  def self.to_s
    "Easy Computer"
  end
end
