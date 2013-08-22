require 'board'
class View
  def set_output(output)
    @output = output
  end

  def board_for_view(board, hash)
    board.spaces.each_slice(board.size).map { |row| row.map {|marker| hash[marker]}.join("|")}
  end


  def available_spaces_for_view(board)
    board.spaces.map.with_index { |space, index|
      space.eql?(Board::BLANK) ? index + 1 : " "
    }.each_slice(board.size).to_a.map {|row| row.join(" ")}
  end

  def player_opponent_list(players)
    "[%s]" % players.map.with_index { |player, index| "%d: %s" % [index+1, player]}.join(", ")
  end
end
