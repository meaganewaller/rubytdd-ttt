require 'board'
require 'human'
require 'easy_computer'
require 'unbeatable_computer'

class Game
  attr_accessor :board, :players, :console

  def initialize(setup)
    @board = Board.new
    @setup = setup
    @console = @setup.console
    @symbols = @setup.player_symbols
    @players = @setup.players.clone
  end

  def play
    while !over?
      system("clear")
      @console.display_board_available_spaces(@board)
      current_mark = @players.first
      space_choice = current_mark.make_move(@board)
      @board.make_move(space_choice, @symbols.key(current_mark))
      @players.rotate!
    end
    @console.display_board(@board)
    display_game_results
  end

  def over?
    @board.winner?(*@symbols.keys) || @board.spaces_taken_by_player(Board::BLANK).empty?
  end

  def winning_player
    @symbols.keys.find { |marker| @board.winner?(marker) }
  end

  def valid_move?(space)
    @board.taken_by_marker(Board::BLANK).include?(space)
  end

  def display_game_results
    if @board.winner?(*@symbols.keys)
      @console.display_winner(winning_player)
    else
      @console.display_tied
    end
  end
end

