require 'human'
require 'easy_computer'
require 'unbeatable_computer'
class SetUp
  attr_reader :console, :players, :player_marks

  PLAYER_LIST = [Human, EasyComputer, UnbeatableComputer]
  def initialize(console)
    @console = console
    @players = []
    @player_marks = {}
  end

  def pick_player
    @players << Human.new
  end

  def pick_opponent
    @players << @console.prompt_opponent_type(PLAYER_LIST).new
  end

  def assign_mark
    @players.each_with_index { |player, index|
      @player_marks["player#{index}".to_sym] = player}
  end

  def get_player_marks(hash)
    marks = {}
    if !hash.empty?
      marker = ""
      while ! ['X', 'O'].include?(marker) do
        $stdout.print("\n", "Choose a marker for #{hash.values.first} ('X' or 'O') : ")
        marker = $stdin.gets.chomp.upcase
      end

      marks[hash.keys.first] = marker
      marks[hash.keys.last] = (['X', 'O'] - [marker]).first
    end
    marks
  end

end
