###
  The Bot Input Handler is responsible for parsing input from
  the game server. It tries to not force any assumptions on
  the player code so most commands are simply transliterated
  into method calls.
###
class BotInputHandler
	input = process.stdin

	constructor: (@bot) ->
	
	run: () ->
		cfg_parser = /^(\S+) (\S+)$/gm
		turn_parser = /// ^
			( h     # h row col owner # ant hill
			| a     # a row col owner # live ant
			| w     # w row col       # water
			| f     # f row col       # food
			| d     # d row col owner # dead ant
			| t...  # turn n          # this turn
			| g.    # go # input complete start sending output
			| e.. ) # end # The game has ended, geme scores will follow
			(?: . (\S+) )? # 0-3 numeric arguments
			(?: . (\S+) )? # 0-3 numeric arguments
			(?: . (\S+) )? # 0-3 numeric arguments
		$ ///gm

		parseTurnN = (turnText) =>
			while cmd = turn_parser.exec turnText
				switch cmd[1]
					when "h"    then @bot.hill  (parseInt cmd[2]), (parseInt cmd[3]), (parseInt cmd[4])
					when "a"    then @bot.ant   (parseInt cmd[2]), (parseInt cmd[3]), (parseInt cmd[4])
					when "w"    then @bot.water (parseInt cmd[2]), (parseInt cmd[3])
					when "f"    then @bot.food  (parseInt cmd[2]), (parseInt cmd[3])
					when "d"    then @bot.dead  (parseInt cmd[2]), (parseInt cmd[3]), (parseInt cmd[4])
					when "turn" then @bot.turn   parseInt cmd[2]
					when "go"   then @bot.go()
					when "end"  then return

		parseTurn0 = (turnText) =>
			cfg = {}
			while setting = cfg_parser.exec turnText
				cfg[setting[1]] = setting[2]
			input.on 'data', parseTurnN
			@bot.ready(cfg)

		input.setEncoding('ascii')  # Pass 'data' input as string.

		input.removeAllListeners()	# Just to be sure...
		input.once 'data', parseTurn0
		
		input.on 'end', -> 
			process.exit()
		
		input.resume()



###
  The output handler is responsible for sending commands
  to the server.
###
class BotOutputHandler
	output = process.stdout
	north: (row, col) -> output.write "#{row} #{col} N\n", 'ascii'
	east:  (row, col) -> output.write "#{row} #{col} E\n", 'ascii'
	south: (row, col) -> output.write "#{row} #{col} S\n", 'ascii'
	west:  (row, col) -> output.write "#{row} #{col} W\n", 'ascii'
	go:               -> output.write "go\n", 'ascii'



###
 A bot doing nothing. A base class to avoid implementing stubs.
###
class NoopBot
	constructor: (@game) ->
	ready: (cfg)   => @game.go()
	hill:  (r,c,o) ->
	ant:   (r,c,o) ->
	water: (r,c)   ->
	food:  (r,c)   ->
	dead:  (r,c,o) ->
	turn:  (n)     ->
	go:            => @game.go()


###
 A trivial game client that also serves the purpose of debugging
 the input parsing.
###
class DebugBot extends NoopBot
	debug = process.stderr
	hill:  (r,c,o) -> debug.write "hill:  #{r} #{c} #{o}\n"
	ant:   (r,c,o) -> debug.write "ant:   #{r} #{c} #{o}\n"
	water: (r,c)   -> debug.write "water: #{r} #{c}\n"
	food:  (r,c)   -> debug.write "food:  #{r} #{c}\n"
	dead:  (r,c,o) -> debug.write "dead:  #{r} #{c} #{o}\n"
	turn:  (n)     -> debug.write "turn:  #{n}\n"


###
 The tutorial step 1 bot.
###
# class Step1Bot extends NoopBot
# 	debug = process.stderr
# 	map: {}
# 	constructor: (@game) ->
# 	ant: (row, col, owner) =>
# 		@map[row,col] = owner

	

game = new BotOutputHandler
botLogic = new DebugBot game
bot = new BotInputHandler botLogic

bot.run()