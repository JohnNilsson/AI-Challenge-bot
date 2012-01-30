{IN, OUT} = require "./BotIo.coffee"

MAP = null

IN.on "ready", (cfg) ->
	{Map} = require "./Map.coffee"
	MAP = new Map(cfg.rows,cfg.cols, IN)
	MAP.print process.stderr
	OUT.go()

IN.on "go", -> 
	MAP.print process.stderr
	OUT.go()

IN.resume()