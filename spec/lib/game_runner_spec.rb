require 'spec_helper'
require 'game'
require 'game_runner'
require 'console'
require 'setup'
require 'view'
require 'input_output'

describe GameRunner do
  before :all do
    @input = StringIO.new('', 'r+')
    @output = StringIO.new('', 'w')
    @io = InputOutput.new
    @io.setup(@input, @output)
    @view = View.new
    @view.set_output(@output)
    @console = Console.new(@io, @view)
    @setup = SetUp.new(@console)
    @runner = GameRunner.new(@setup)
  end

  before :each do
    @test_game = double("Game").as_null_object
    @test_game.stub(:new).and_return(@test_game)
    @setup.stub(:config)
    @console.stub(:play_again).and_return(false)
  end

  it "calls config from setup" do
    @setup.should_receive(:config)
    @runner.run(@test_game)
  end

  it "creates an instance of Game" do
    @test_game.should_receive(:new).with(@setup).and_return(@test_game)
    @runner.run(@test_game)
  end

  it "runs an instance of game" do
    @test_game.should_receive(:play)
    @runner.run(@test_game)
  end

  it "asks user to play again" do
    @console.should_receive(:play_again)
    @runner.run(@test_game)
  end

  it "run continues as long as player keeps playing" do
    @console.should_receive(:play_again).and_return(1, 0)
    @runner.run(@test_game)
  end
end
