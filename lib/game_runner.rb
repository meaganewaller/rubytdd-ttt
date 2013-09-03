require 'board'
class GameRunner

  def initialize(setup)
    @setup = setup
  end

  def run(game)
    keep_playing = 2
    while keep_playing == 2
      @setup.config
      current_game = game.new(@setup)
      current_game.play
      keep_playing = @setup.console.play_again
      while keep_playing == 1
        current_game.board.reset_board
        current_game.play
        keep_playing = @setup.console.play_again
      end
    end
    keep_playing
  end
end
