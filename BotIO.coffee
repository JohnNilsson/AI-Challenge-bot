{EventEmitter} = require "events"

###
  This module is responsible for parsing input from, and render output to,
  the game server. It tries to not force any assumptions on
  the player code so most input are simply transliterated
  into events.
###

output = process.stdout
input = process.stdin

input.setEncoding 'ascii'  # Pass 'data' input as string.



G = new EventEmitter

G.startGame = -> input.resume()

# Commands
G.north = (row, col) -> output.write "o #{row} #{col} N\n", 'ascii'
G.east  = (row, col) -> output.write "o #{row} #{col} E\n", 'ascii'
G.south = (row, col) -> output.write "o #{row} #{col} S\n", 'ascii'
G.west  = (row, col) -> output.write "o #{row} #{col} W\n", 'ascii'
G.go    =            -> output.write "go\n", 'ascii'



# Input

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
			when "h"    then G.emit "hill",  (parseInt cmd[2]), (parseInt cmd[3]), (parseInt cmd[4])
			when "a"    then G.emit "ant",   (parseInt cmd[2]), (parseInt cmd[3]), (parseInt cmd[4])
			when "w"    then G.emit "water", (parseInt cmd[2]), (parseInt cmd[3])
			when "f"    then G.emit "food",  (parseInt cmd[2]), (parseInt cmd[3])
			when "d"    then G.emit "dead",  (parseInt cmd[2]), (parseInt cmd[3]), (parseInt cmd[4])
			when "turn" then G.emit "turn",   parseInt cmd[2]
			when "go"   then G.emit "go"
			when "end"  then return

input.once 'data', (turnText) ->
	cfg_parser = /^(\S+) (\S+)$/gm
	cfg = {}
	while setting = cfg_parser.exec turnText
		cfg[setting[1]] = setting[2]
	input.on 'data', parseTurn
	G.emit "ready", cfg

module.exports = G
