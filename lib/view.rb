require 'board'
class View

  def set_output(output)
    @output = output
  end

  def board_for_view(board, hash)
    board.spaces.each_slice(board.size).map do |row|
      row.map { |marker| hash[marker] }.join("|")
    end
  end

  def available_spaces_for_view(board)
    board.spaces.map.with_index do |space, index|
      space.eql?(Board::BLANK) ? index + 1 : " "
    end.each_slice(board.size).map { |row| row.join(" ") }
  end

  def player_opponent_list(players)
    players.map.with_index do |player, index|
      "#{index + 1}: #{player}"
    end.join(', ')
  end
end
