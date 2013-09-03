require 'board'
require 'input_output'
require 'view'
class Console
  attr_reader :markers, :view, :io, :in, :out

  def initialize(input = $stdin, output = $stdout)
    @io = InputOutput.new
    @io.setup(input, output)
    @view = View.new
    @view.set_output(output)
    @markers = Hash.new
    @markers[Board::BLANK] = "_"
    @in = input
    @out = output
  end

  def set_markers(player_marks)
    marks = player_marks.keys
    @markers[marks.first] = get_player_marks
    opponent_mark = (['X', 'O'] - [@markers[marks.first]]).first
    @markers[marks.last] = opponent_mark
  end

  def get_player_marks
    message = "Please choose your marker ('X' or 'O') "
    @io.valid_input = ['X', 'O']
    @io.request("\n", message)
  end

  def display_board(board)
    displayed = @view.board_for_view(board, @markers).map { |row| "%10s" % row }
    @out.puts("", *displayed)
  end

  def display_board_available_spaces(board)
    displayed_board = @view.board_for_view(board, @markers)
    displayed_available = @view.available_spaces_for_view(board)
    displayed = (0...displayed_board.size).map { |x|
      "%10s%10s" % [displayed_board[x], displayed_available[x]]
    }
    @out.puts("", *displayed)
  end

  def get_player_space
    message = "Pick a Space to Move or Press 'Q' to Quit : "
    @io.valid_input = ('1'..'9').to_a.push('Q')
    result = @io.request("\n", message)
    if result == "Q"
      quit_game_anytime
    else
      result.to_i - 1
    end
  end

  def quit_game_anytime
    exit
  end

  def get_opponent_type(opponents)
    opponent_types = @view.player_opponent_list(opponents)
    message = "Choose an opponent #{opponent_types} : "

    @io.valid_input = (1..opponents.length).map { |v| v.to_s }
    value = @io.request("\n", message).to_i
    opponents[value - 1]
  end

  def get_player_order
    player_x = @markers.key('X')
    player_o = @markers.key('O')
    [player_x, player_o]
  end

  def play_again
    message = "Would you like to [e]xit, [r]estart, or [s]tart a new game? "

    game_states = { 'e' => 0, 'r' => 1, 's' => 2 }

    @io.valid_input = game_states.keys
    user_input = @io.request("\n", message)

    game_states[user_input]
  end

  def alert_space_invalid(space)
    @out.puts("", "Please Pick a Valid Space")
  end

  def display_winner(player_marker)
    @out.puts("", "Player #{@markers[player_marker]} is the winner")
  end

  def display_tied
    @out.puts("", "Tied game")
  end
end
