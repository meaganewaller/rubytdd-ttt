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
    @markers = @setup.player_marks
    @players = @setup.players.clone
  end

  def play
    while !over?
      @console.display_board_available_spaces(@board)
      current_mark = @players.first
      space_choice = current_mark.place_mark(@board)
      @board.place_mark(space_choice, @markers.key(current_mark))
      @players.rotate!
    end
    @console.display_board(@board)
    display_game_results
  end

  def over?
    @board.winner?(*@markers.keys) || @board.taken_by_marker(Board::BLANK).empty?
  end

  def winning_marker
    @markers.keys.select { |marker| @board.winner?(marker)}.first
  end

  def valid_move?(space)
    @board.taken_by_marker(Board::BLANK).include?(space)
  end

  def display_game_results
    if @board.winner?(*@markers.keys)
      @console.display_winner(winning_marker)
    else
      @console.display_tied
    end
  end
end

