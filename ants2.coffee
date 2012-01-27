###
 A bot doing nothing. A base class to avoid implementing stubs.
###
class NoopBot
	constructor: (i,o) ->
		i.on "ready", -> o.go()
		i.on "go", -> o.go()


###
 A trivial game client that also serves the purpose of debugging
 the input parsing.
###
class DebugBot extends NoopBot
	constructor: (@in, @out) ->
		super @in, @out
		debug = process.stderr
		@in.on "hill",  (r,c,o) -> debug.write "hill:  #{r} #{c} #{o}\n"
		@in.on "ant",   (r,c,o) -> debug.write "ant:   #{r} #{c} #{o}\n"
		@in.on "water", (r,c)   -> debug.write "water: #{r} #{c}\n"
		@in.on "food",  (r,c)   -> debug.write "food:  #{r} #{c}\n"
		@in.on "dead",  (r,c,o) -> debug.write "dead:  #{r} #{c} #{o}\n"
		@in.on "turn",  (n)     -> debug.write "turn:  #{n}\n"

###
 The tutorial step 1 bot.
###
# class Step1Bot extends NoopBot
# 	debug = process.stderr
# 	map: {}
# 	constructor: (@game) ->
# 	ant: (row, col, owner) =>
# 		@map[row][col] = owner

{IN, OUT} = require "./BotIo.coffee"

bot = new DebugBot(IN, OUT)

IN.resume()