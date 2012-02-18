###
A priority queue implementation
###

module.exports = class BinaryHeap
	constructor: ->
		@data = [null]

	_swap = (data, i1, i2) ->
		t = data[i1]
		data[i1] = data[i2]
		data[i2] = t

	_bubble_up = (data, c = data.length - 1) ->
		return if c == 1
		p = Math.floor c / 2
		if data[c].k < data[p].k
			_swap data, c, p
			_bubble_up data, p

	_bubble_down = (data, p = 1) ->
		c1 = p * 2
		c2 = c1 + 1
		return if c1 >= data.length
		pp  = data[p].k
		c1p = data[c1].k
		c2p = data[c2]?.k

		if c2p != undefined && c2p < c1p && c2p < pp
			_swap data, c2, p
			_bubble_down data, c2
		else if c1p < pp
			_swap data, c1, p
			_bubble_down data, c1

	min: => @data[1]?.v

	add: (prio, elem) =>
		@data.push
			k: prio
			v: elem
		_bubble_up @data

	pop: =>
		if @data.length < 2
			return undefined
		if @data.length == 2
			return @data.pop().v

		ret = @data[1].v
		@data[1] = @data.pop()
		_bubble_down @data
		ret
