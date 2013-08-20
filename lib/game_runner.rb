class GameRunner
  def initialize(setup)
    @setup = setup
  end

  def run(game)
    keep_playing = true
    while keep_playing
      @setup.config
      game.new(@setup).play
      keep_playing = @setup.console.play_again
    end
  end
end
