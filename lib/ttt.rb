class TicTacToe
  def prompt_opponent_type
    puts "Would you like to play against a (h)uman?"
    opponent = $stdin.gets.chomp.downcase
      if opponent == "h"
        opponent = :human
      end
  end
end
