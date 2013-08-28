require 'human'
require 'easy_computer'
require 'unbeatable_computer'

class SetUp
  attr_reader :console, :players, :player_symbols

  PLAYER_LIST = [Human, EasyComputer, UnbeatableComputer]

  def initialize(console)
    @console = console
    @players = []
    @player_symbols = {}
  end

  def config
    pick_player
    pick_opponent
    assign_player_symbols
    assign_marks
    assign_player_order
  end

  def pick_player
    @players[0] = Human.new
    @players[0].console = @console
  end

  def pick_opponent
    @players[1] = @console.get_opponent_type(PLAYER_LIST).new
    @players[1].console = @console
  end

  def assign_player_symbols
    @players.each_with_index do |player, index|
      @player_symbols["player#{index}".to_sym] = player
      player.mark = @player_symbols.key(player)
    end
  end

  def assign_marks
    @console.set_markers(@player_symbols)
  end

  def assign_player_order
    order = @console.get_player_order
    @players.each_index do |index|
      @players[index] = @player_symbols[order[index]]
    end
  end
end
