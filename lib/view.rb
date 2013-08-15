class View
  def output(out)
    @out = out
  end

  def board_rep_view(board, hash)
    board.spaces.each_slice(board.size).map { |row| row.map {|mark| hash[mark]}.join("|")}
  end

  def players_list(players)
    "[%s]" % players.map.with_index { |player, index| "%d: %s" % [index+1, player]}.join(", ")
  end

  def available_spaces_for_view(board)
    board.spaces.map.with_index { |space, index|
      space == (Board::BLANK) ? index + 1 : " "}.each_slice(board.size).to_a.map { |row| row.join(" ") }
  end
end
