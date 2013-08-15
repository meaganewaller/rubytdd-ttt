$: << File.join(File.expand_path(File.dirname("__FILE__")), "/lib")

require 'game'
require 'console'
require 'input_output'
require 'view'

io = InputOutput.new
io.setup($stdin, $stdout)
view = View.new
view.output($stdout)
console = Console.new(io, view)
game = Game.new(console)
game.play
