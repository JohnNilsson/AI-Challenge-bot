debug = (require 'fs').createWriteStream 'Debug.dump'




class GameInputHandler
	constructor: (eventHandler) ->
		@e = eventHandler ? new BaseGameEventHandler()
	
	run: ->
		input = process.stdin

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
					when "h"    then @e.hill  (parseInt cmd[2]), (parseInt cmd[3]), (parseInt cmd[4])
					when "a"    then @e.ant   (parseInt cmd[2]), (parseInt cmd[3]), (parseInt cmd[4])
					when "w"    then @e.water (parseInt cmd[2]), (parseInt cmd[3])
					when "f"    then @e.food  (parseInt cmd[2]), (parseInt cmd[3])
					when "d"    then @e.dead  (parseInt cmd[2]), (parseInt cmd[3]), (parseInt cmd[4])
					when "turn" then @e.turn   parseInt cmd[2]
					when "go"   then @e.go()
					when "end"  then return

		parseTurn0 = (turnText) =>
			cfg = {}
			while setting = cfg_parser.exec turnText
				cfg[setting[1]] = setting[2]
			input.on 'data', parseTurnN
			@e.init(cfg)

		input.setEncoding('ascii')  # Pass 'data' input as string.

		input.removeAllListeners()	# Just to be sure...
		input.once 'data', parseTurn0
		
		input.on 'end', -> 
			process.exit()
		
		input.resume()




class DebugGameEventHandler
	init:  (cfg)   -> process.stdout.write "go\n"
	hill:  (r,c,o) -> debug.write "hill:  #{r} #{c} #{o}\n"
	ant:   (r,c,o) -> debug.write "ant:   #{r} #{c} #{o}\n"
	water: (r,c)   -> debug.write "water: #{r} #{c}\n"
	food:  (r,c)   -> debug.write "food:  #{r} #{c}\n"
	dead:  (r,c,o) -> debug.write "dead:  #{r} #{c} #{o}\n"
	turn:  (n)     -> debug.write "turn:  #{n}\n"
	go:     -> process.stdout.write "go\n"



(new GameInputHandler new DebugGameEventHandler()).run()