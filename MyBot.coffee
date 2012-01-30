Game = require "./BotIo.coffee"
Map = require "./Map.coffee"

MAP = null
Game.on "ready", (cfg) ->
	MAP = new Map(cfg.rows, cfg.cols)
	Game.on "go",    MAP.resetMap
	Game.on "ant",   MAP.markAntOnMap
	Game.on "ant",   MAP.markTileAsLand
	Game.on "water", MAP.markTileAsWater
	Game.on "food",  MAP.markFoodOnMap
	Game.on "food",  MAP.markTileAsLand
	Game.on "hill",  MAP.markTileAsHill

	MAP.print process.stderr
	Game.go()

Game.on "go", -> 
	MAP.print process.stderr
	Game.go()

Game.startGame()