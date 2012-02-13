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
MYHILL  = 0

class Ant
	constructor: (@owner, @tile) ->

	toString: ->
		if @tile.type == @owner # The only hill an ant can occupy
			ANT[@owner].toUpperCase()
		else
			ANT[@owner]

	possibleMoves: =>
		dirs = ['west', 'north', 'east', 'south']
		passable = ( @tile[dir].isPassable() for dir in dirs )
		(dir for dir in dirs when @tile[dir].isPassable())

	go: (dir) =>
		t = @tile[dir]
		if t.type == UNSEEN
			t.type = LAND
		# process.stderr.write ""+dir+"\n"
		# process.stderr.write ""+@tile+"("+@tile.row+","+@tile.col+")"+"\n"
		# process.stderr.write ""+t+"("+t.row+","+t.col+")"+"\n"
		# process.stderr.write ""+t.isPassable()+"\n"
		if t.isPassable()
			@tile.occupant = null
			t.occupant = @
			@tile = t
			return true
		return false

class Food
	constructor: (@tile) ->
	toString: -> FOOD

class Tile
	constructor: (@row,@col) ->
		@type = UNSEEN

	toString: =>
		if @occupant then @occupant.toString() else @type

	isPassable: =>
		not @occupant && (@type == LAND || @type == MYHILL || @type == UNSEEN)

class Map
	createTiles = (height, width) ->
		tiles = new Array height
		north = null
		for row in [0...height]
			tr = new Array width
			tiles[row] = tr
			west = null
			for col in [0...width]
				t = new Tile row, col
				tr[col] = t
				if west
					t.west = west
					west.east = t
				if north
					n = north[col]
					t.north = n
					n.south = t
				west = t
			tr[0].west = west
			west.east = tr[0]
			north = tr
		for t in tiles[0]
			t.north = north[t.col]
			north[t.col] = t
		tiles

	resetMap: =>
		for as in @ants[1...@ants.length]
			for a in as
				a.tile.occupant = null
		@ants = []
		for f in @food
			f.tile.occupant = null
		@food = []

	markAntOnMap: (row, col, owner) =>
		tile = @tiles[row][col]
		if owner == 0 && tile.occupant == 0
			return # This is our ant
		ant = new Ant(owner, tile)
		tile.occupant = ant
		ants = (@ants[owner] or= [])
		ants.push ant

	markFoodOnMap: (row, col) =>
		tile = @tiles[row][col]
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

	myAnts: => @ants[0]

module.exports = Map
