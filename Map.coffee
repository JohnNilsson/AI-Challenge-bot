###
# A simple map
###

### Legend
# .   = land
# %   = water
# *   = food
# !   = dead ant or ants
# ?   = unseen territory
# a-j = ant
# A-J = ant on its own hill
# 0-9 = hill
###

# Terrain
LAND    = '.'
WATER   = '%'
UNSEEN  = '?'
ANT     = ['a','b','c','d','e','f','g','h','i','j']
FOOD    = '*'

class Ant
	constructor: (@owner, @tile) ->
	toString: ->
		if @tile.type == @owner # The only hill an ant can occupy
			ANT[@owner].toUpperCase()
		else
			ANT[@owner]

class Food
	constructor: (@tile) ->
	toString: -> FOOD

class Tile
	constructor: (@x,@y) ->
		@type = UNSEEN

	toString: =>
		if @occupant then @occupant.toString() else @type

class Map
	createTiles = (height, width) ->
		tiles = new Array height
		for row in [0...height]
			tiles[row] = new Array width
			for col in [0...width]
				t = new Tile row, col
				
				if col > 0
					t.left = tiles[row][col-1]
					t.left.right = t

				if col == width - 1
					tiles[row][0].left = t
				
				if row > 0
					t.up = tiles[row-1][col]
					t.up.down = t
				
				if row == height - 1
					tiles[0][col].up = t

				tiles[row][col] = t
		tiles
	
	resetMap: =>
		for as in @ants
			for a in as
				a.tile.occupant = null
		@ants = []
		for f in @food
			f.tile.occupant = null
		@food = []

	markAntOnMap: (row, col, owner) =>
		tile = @tiles[row][col]
		ant = new Ant(owner, tile)
		tile.occupant = ant
		ants = @ants[owner] or= []
		ants.push ant
	
	markFoodOnMap: (row, col) =>
		t = @tiles[row][col]
		food = new Food(tile)
		tile.occupant = food
		@food.push food			

	markTileAsWater: (row, col) => 
		@tiles[row][col].type = WATER
	
	markTileAsLand: (row, col) =>
		t = @tiles[row][col]
		if t.type == UNSEEN
			t.type = LAND 
	
	markTileAsHill: (row, col, owner) =>
		@tiles[row][col].type = owner
	
	print: (stream) =>
		for row in @tiles
			stream.write "m "+(tile.toString() for tile in row).join("") + "\n"

	constructor: (@height, @width) ->
		@tiles = createTiles height, width
		@ants = []
		@food = []

module.exports = Map