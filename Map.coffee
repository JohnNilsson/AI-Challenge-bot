###
# A simple map
###


class Tile
	constructor: (@x,@y) ->
	toString: -> "<#{@x},#{@y}>"

class Map
	constructor: (width, height) ->
		@tiles = new Array height
		for row in [0...height]
			@tiles[row] = new Array width
			for col in [0...width]
				t = new Tile row, col
				
				if col > 0
					t.left = @tiles[row][col-1]
					t.left.right = t

				if col == width - 1
					@tiles[row][0].left = t
				
				if row > 0
					t.up = @tiles[row-1][col]
					t.up.down = t
				
				if row == height - 1
					@tiles[0][col].up = t

				@tiles[row][col] = t