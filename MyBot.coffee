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
	Game.go()

Game.on "go", -> 
	for ant in MAP.myAnts()
		for dir in ['north', 'east', 'south', 'west']
			[r, c] = [ant.tile.row, ant.tile.col]
			if ant.go dir
				Game[dir] r,c
				break
	Game.go()

Game.startGame()