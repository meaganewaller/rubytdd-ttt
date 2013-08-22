require 'setup'
require 'human'
require 'easy_computer'
require 'unbeatable_computer'

describe SetUp do
  before :each do
    @console = double("Console").as_null_object
    @setup = SetUp.new(@console)
  end

  it "has list of all opponents" do
    SetUp::PLAYER_LIST.should == [Human,EasyComputer,UnbeatableComputer]
  end

  context "at new" do
    it "has reference to console" do
      @setup.console.should == @console
    end

    it "has empty player list" do
      @setup.players.should == []
    end

    it "has empty markers for players " do
      @setup.player_marks.should == {}
    end
  end

  context "when picking players" do
    before :each do
      @player2 = double("Player").as_null_object
      @console.stub(:get_opponent_type).and_return(@player2)
      @player2.stub(:new).and_return(@player2)
    end

    it "has instance of 'Human' in players" do
      @setup.pick_player
      @setup.players.first.should be_instance_of(Human)
    end

    it "gets request from console for opponent choice" do
      @console.should_receive(:get_opponent_type).with(SetUp::PLAYER_LIST).and_return(@player2)
      @setup.pick_opponent
    end

    it "has instance of opponent type" do
      @setup.pick_opponent
      @setup.players.last.should == @player2
    end

    it "overwrites an existing player" do
      @setup.pick_player
      original = @setup.players[0]
      @setup.pick_player
      @setup.players[0].should_not == original
    end

    it "overwrites an existing opponent" do
      @console.stub(:get_opponent_type).and_return(Human)
      @setup.pick_player
      @setup.pick_opponent
      original = @setup.players[1]
      @setup.pick_opponent
      @setup.players[1].should_not == original
    end

    it "each player has reference to console" do
      @console.stub(:get_opponent_type).and_return(Human)
      @setup.pick_player
      @setup.pick_opponent
      @setup.players.each do |player|
        player.console.should == @setup.console
      end
    end
  end

  context "when picking markers" do
    before :each do
      @player2 = double("Player").as_null_object
      @console.stub(:get_opponent_type).and_return(@player2)
      @player2.stub(:new).and_return(@player2)
      @setup.pick_player
      @setup.pick_opponent
      @setup.assign_player_marks
    end

    it "assigns marks by player index" do
      @setup.player_marks[:player0].should == @setup.players[0]
      @setup.player_marks[:player1].should == @setup.players[1]
    end

    it "assigns unique marker to each player" do
      @setup.players.each do |player|
        @setup.player_marks.should have_value(player)
      end
    end
  end

  it "calls config methods in sequence" do
    method_sequence = [:pick_player, :pick_opponent, :assign_player_marks, :assign_marks]
    call_sequence = []
    method_sequence.each do |method|
      @setup.should_receive(method) { call_sequence << method }
    end
    @setup.config
    call_sequence.should == method_sequence
  end

  it "assign marks to the console" do
    @console.stub(:get_opponent_type).and_return(Human)
    @setup.pick_player
    @setup.pick_opponent
    @setup.assign_player_marks
    markers = @setup.player_marks
    @console.should_receive(:set_markers).with(markers)
    @setup.assign_marks
  end

  it "orders the players" do
    @console.stub(:get_opponent_type).and_return(Human)
    @setup.pick_player
    @setup.pick_opponent
    @setup.assign_player_marks
    original = @setup.players.clone
    @console.stub(:get_player_order).and_return([:player1, :player0])
    @setup.assign_order
    @setup.players.should == original.reverse
  end

  it "stores users settings" do
    # test to make sure that the user settings are stored for future game restarts
  end
end
