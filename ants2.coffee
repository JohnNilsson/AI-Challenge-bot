Game = require "./BotIo.coffee"

###
 A bot doing nothing. A base class to avoid implementing stubs.
###
class NoopBot
	constructor: (game) ->
		game.on "ready", -> o.go()
		game.on "go", -> o.go()


###
 A trivial game client that also serves the purpose of debugging
 the input parsing.
###
class DebugBot extends NoopBot
	constructor: (game) ->
		super game
		debug = process.stderr
		game.on "hill",  (r,c,o) -> debug.write "hill:  #{r} #{c} #{o}\n"
		game.on "ant",   (r,c,o) -> debug.write "ant:   #{r} #{c} #{o}\n"
		game.on "water", (r,c)   -> debug.write "water: #{r} #{c}\n"
		game.on "food",  (r,c)   -> debug.write "food:  #{r} #{c}\n"
		game.on "dead",  (r,c,o) -> debug.write "dead:  #{r} #{c} #{o}\n"
		game.on "turn",  (n)     -> debug.write "turn:  #{n}\n"

bot = new DebugBot(Game)

Game.startGame()