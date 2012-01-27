###
  This module is responsible for parsing input from, and render output to,
  the game server. It tries to not force any assumptions on
  the player code so most input are simply transliterated
  into events.
###
{EventEmitter} = require "events"


###
  Output
###
output = process.stdout
O =
	north: (row, col) -> output.write "#{row} #{col} N\n", 'ascii'
	east:  (row, col) -> output.write "#{row} #{col} E\n", 'ascii'
	south: (row, col) -> output.write "#{row} #{col} S\n", 'ascii'
	west:  (row, col) -> output.write "#{row} #{col} W\n", 'ascii'
	go:               -> output.write "go\n", 'ascii'
(exports ? this).OUT = O


###
  Input
###
input = process.stdin
input.setEncoding('ascii')  # Pass 'data' input as string.
input.removeAllListeners()	# Just to be sure...
input.on 'end', -> process.exit()

I = new EventEmitter
I.resume = -> input.resume()


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

parseTurn = (turnText) ->
	while cmd = turn_parser.exec turnText
		switch cmd[1]
			when "h"    then I.emit "hill",  (parseInt cmd[2]), (parseInt cmd[3]), (parseInt cmd[4])
			when "a"    then I.emit "ant",   (parseInt cmd[2]), (parseInt cmd[3]), (parseInt cmd[4])
			when "w"    then I.emit "water", (parseInt cmd[2]), (parseInt cmd[3])
			when "f"    then I.emit "food",  (parseInt cmd[2]), (parseInt cmd[3])
			when "d"    then I.emit "dead",  (parseInt cmd[2]), (parseInt cmd[3]), (parseInt cmd[4])
			when "turn" then I.emit "turn",   parseInt cmd[2]
			when "go"   then I.emit "go"
			when "end"  then return

input.once 'data', (turnText) ->
	cfg_parser = /^(\S+) (\S+)$/gm
	cfg = {}
	while setting = cfg_parser.exec turnText
		cfg[setting[1]] = setting[2]
	input.on 'data', parseTurn
	I.emit "ready", cfg

(exports ? this).IN = I