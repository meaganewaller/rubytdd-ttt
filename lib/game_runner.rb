require 'board'
class GameRunner
  def initialize(setup)
    @setup = setup
  end

  def run(game)
    keep_playing = 2
    while keep_playing == 2
      @setup.config
      this_game = game.new(@setup)
      this_game.play
      keep_playing = @setup.console.play_again
      while keep_playing == 1
        this_game.board.reset_board
        this_game.play
        keep_playing = @setup.console.play_again
      end
    end
    keep_playing
  end
end
