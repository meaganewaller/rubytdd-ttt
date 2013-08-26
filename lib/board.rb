BOARD_SIZE = 3

class Board
  attr_reader :size, :spaces, :solutions, :markers_added
  BLANK = :blank

  def initialize(size = BOARD_SIZE)
    @size = size
    reset
    winning_solutions
  end

  def reset
    @spaces = [BLANK]*@size.to_i ** 2
    @markers_added = []
  end

  def make_move(space, mark)
    @spaces[space] = mark
    update_markers_added
  end

  def is_space_available?(space)
    space < @spaces.length && space >= 0 && @spaces[space] == BLANK
  end

  def taken_by_marker(mark)
    @spaces.map.with_index { |marker, index| index if marker == mark }.compact
  end

  def winner?(*marks)
    has_winner = false
    marks.each do |mark|
      taken_spaces = taken_by_marker(mark)
      @solutions.each { |solution| has_winner |= (solution - taken_spaces).empty? }
    end
    has_winner
  end

  def winning_solutions
    @solutions = [
      [0,1,2],[3,4,5],[6,7,8],
      [0,3,6],[1,4,7],[2,5,8],
      [0,4,8],[2,4,6]
    ]
  end

  def update_markers_added
    @markers_added = @spaces.uniq - [BLANK]
  end
end
