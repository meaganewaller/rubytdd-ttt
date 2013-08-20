$: << File.join(File.expand_path(File.dirname("__FILE__")), "/lib")

require 'game'
require 'setup'
require 'console'
require 'input_output'
require 'view'
require 'game_runner'


console = Console.new($stdin, $stdout)
setup = SetUp.new(console)
runner = GameRunner.new(setup)
runner.run(Game)
