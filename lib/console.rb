require 'board'
class Console
  attr_reader :marker
  attr_accessor :out

  def initialize(io, view)
    @io = io
    @view = view
    @marker = Hash.new
    @marker[Board::BLANK] = "_"
    @out = $stdout
  end

  def set_players_markers(players)
    @players = players.clone
    @marker[players.first] = "X"
    @marker[players.last] = "O"
  end

  def opponent_option_list(opponents)
    "[%s]" % opponents.map.with_index { |opponent, index| "%i: %s" % [index+1, opponent]}.join(", ")
  end

  def display_board(board)
    print_board = @view.board_rep_view(board, @marker)
    print_available = @view.available_spaces_for_view(board)
    output = (0...board.size).map { |space|
      "%10s%10s" % [print_board[space], print_available[space]]}
      @out.puts("", *output)
  end

  def convert_board_for_commandline_view(board)
    board.spaces.each_slice(board.size).map { |row| row.map {
      |mark| @marker[mark]}.join("|")}
  end

  def prompt_opponent_type(opponents)
    opponent_types = @view.players_list(opponents)
    message = "Choose Opponent #{opponent_types} : "
    @io.valid_input = (1..opponents.length).map { |opp| opp.to_s }
    value = @io.request("\n", message).to_i
    opponents[value - 1]
  end

  def pick_marker
    message = "Please Choose Your Marker 'X' or 'O': "
    @io.valid_input = ["X", "O"]
    @io.request("\n", message)
  end

  def get_player_mark
    message = "Choose the number corresponding with the space you'd like to move: "
    @io.valid_input = ('1'..'9').to_a
    result = @io.request("\n", message)
    result.to_i - 1
  end

  def space_unavailable(space)
    @out.puts("","Invalid Choice! Please Choose a Valid Space")
  end

  def convert_available_spaces_for_commandline_view(board)
     board.spaces.map.with_index { |space, index| space == Board::BLANK ? index + 1 : " "}.each_slice(board.size).to_a.map { |row| row.join(" ")}
  end

  def display_game_results(board)
    output = @view.board_rep_view(board, @marker).map { |row| "%10s" % row }
    message = if board.winner?(*@players)
    winning_player = board.winner?(@players.first) ? "X" : "O" 
    "Player #{winning_player} wins"
              else
                "Tied Game"
              end
    @out.puts("", *output, "", message)
  end

  def play_again?
    message = "Play Again? (y/n) : "
    @io.valid_input = ['y', 'n']
    play_again = @io.request("\n", message)
    play_again == "y" ? true : false
  end

  def get_marks(hash)
    marks, marker = {}, ""
    message = "Choose a mark for #{hash.values.first} ('X' or 'O'): "
    @io.valid_input = ['X', 'O']
    marker = @io.request("\n", message)
    marks[hash.keys.first] = marker
    marks[hash.keys.last] = (['X', 'O'] - [marker]).first
   marks
  end
end
