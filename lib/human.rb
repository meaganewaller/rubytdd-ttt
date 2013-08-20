class Human
  attr_accessor :console, :mark

  def place_mark(board)
    space = @console.get_player_space
    while !board.is_space_available?(space)
      @console.alert_space_invalid(space)
      space = @console.get_player_space
    end
    space
  end

  def self.to_s
    "Human"
  end
end
