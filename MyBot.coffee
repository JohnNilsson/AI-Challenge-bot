Game = require "./BotIO.coffee"
Map = require "./Map.coffee"


class FirstPassableDirStrategy
	move: (ant) ->
		if dir = ant.possibleMoves()[0]
			Game[dir] ant.tile.row, ant.tile.col
			ant.go dir

class DecayStrategy
	constructor: (Game) ->
		Game.on "go", ->
			for row in MAP.tiles
				for tile in row
					tile.scent = Math.max(tile.scent ? 0 - 1, 0)

	move: (ant) ->
		ant.tile.scent = 9
		dirs = ant.possibleMoves()
		dirs.sort (a,b) -> ant.tile[a].scent - ant.tile[b].scent # Preferr weakest scent
		# process.stderr.write "Option: #{("#{dir}:#{ant.tile[dir].scent}" for dir in dirs)}\n"
		if dir = dirs[0]
			Game[dir] ant.tile.row, ant.tile.col
			ant.go dir

MAP = null
STRATEGY = new DecayStrategy(Game)

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
	STRATEGY.move(ant) for ant in MAP.myAnts()
	Game.go()

Game.startGame()

