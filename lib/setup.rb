require 'human'
require 'easy_computer'
require 'unbeatable_computer'
require 'board'

class SetUp
  attr_reader :console, :players, :player_marks

  PLAYER_LIST = [Human, EasyComputer, UnbeatableComputer]

  def initialize(console)
    @console = console
    @players = []
    @player_marks = {}
  end

  def config
    pick_player
    pick_opponent
    assign_player_marks
    assign_marks
    assign_order
  end

  def pick_player
    @players[0] = Human.new
    @players[0].console = @console
  end

  def pick_opponent
    @players[1] = @console.get_opponent_type(PLAYER_LIST).new
    @players[1].console = @console
  end

  def assign_player_marks
    @players.each_with_index do |player, index|
      @player_marks["player#{index}".to_sym] = player
      player.mark = @player_marks.key(player)
    end
  end

  def assign_order
    order = @console.get_player_order
    @players.each_index do |index|
      @players[index] = @player_marks[order[index]]
    end
  end

  def assign_marks
    @console.set_markers(@player_marks)
  end
end
