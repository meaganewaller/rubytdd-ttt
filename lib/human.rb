class Human 
  attr_accessor :console

  def place_mark(board)
    space = @console.get_player_mark
    while !board.is_space_available?(space)
      @console.space_unavailable(space)
      space = @console.get_player_mark
    end
    board.place_mark(space, self)
  end

  def self.to_s
    "Human"
  end
end
