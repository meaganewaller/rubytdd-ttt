require 'board'
require 'human'
require 'easy_computer'
require 'unbeatable_computer'

class Game
  attr_accessor :board, :players, :console, :player_types

  def initialize(console)
    @board = Board.new
    @console = console
    @player_types = [Human,EasyComputer,UnbeatableComputer]
    @players = []
  end

  def play
    playing = true
    while playing do
      @board.reset
      set_players
      while !over?
        @console.display_board(@board)
        @players.first.place_mark(@board)
        @players.rotate!
      end
    @console.display_game_results(@board)
    playing = @console.play_again?
    end
  end

  def over?
    @board.winner?(*@players) || @board.taken_by_marker(Board::BLANK).empty?
  end

  def set_players
    @players = []
    @players << @player_types.first.new
    opponent_type = @console.prompt_opponent_type(@player_types)
    if opponent_type == Human
      @players << opponent_type.new
    else
      @players << opponent_type.new(@players.first)
    end
    @players.each { |player| player.console = @console }
    @console.set_players_markers(@players)
  end
end
