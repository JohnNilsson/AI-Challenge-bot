###
A reference priority queue
###
class NaivePriorityQueue
	constructor: ->
		@data = []

	min: => @data[0]?.val

	add: (prio, data) =>
		@data.push
			key: prio
			val: data
		@data.sort (a, b) => a.key - b.key
		undefined

	pop: -> @data.shift()?.val


###
Some test data generators
###
arbBool = ->
	Math.random() >= 0.5

arbInt = ->
	sign = arbBool() ? 1 : -1;
	sign * Math.floor 100 * Math.random();

arbPrios = ->
	arbInt() for _ in [0...100]

arbQueueOp = ->
	switch Math.floor 3 * Math.random()
		when 0
			op: "min"
			args: undefined
		when 1
			op: "pop"
			args: undefined
		when 2
			p = arbInt()
			op: "add"
			args: [p, p]



###
The SUT
###
PQ = require '../PriorityQueue.coffee'



###
The actual tests
###
testCases =
	'Queue can be created': (q) ->
		@ok q

	'Elements can be inserted': (q) ->
		q.add 1, "test"

	'Empty queue has no mimimum': (q) ->
		@ok q.min() == undefined

	'The minimum after one insert is the inserted element': (q) ->
		q.add 1, "test"
		@equals q.min(), "test"

	'The mimimum is allways the inserted element with lowest prio': (q) ->
		q.add 3, "3"
		@equals q.min(), "3"
		q.add 1, "1"
		@equals q.min(), "1"
		q.add 4, "4"
		@equals q.min(), "1"
		q.add 2, "2"
		@equals q.min(), "1"

	'The mimimum is reevaluated when elements are removed': (q) ->
		q.add 3, "3"
		q.add 1, "1"
		q.add 4, "4"
		q.add 2, "2"
		@equals q.pop(), "1", "First element should be 1"
		@equals q.pop(), "2", "Second element should be 2"
		@equals q.pop(), "3", "Third element should be 3"
		@equals q.pop(), "4", "Last element should be 4"

	'Removing the last element leaves an empty queue': (q) ->
		q.add 1, "test"
		@equals q.pop(), "test"
		@equals q.pop(), undefined

	'It behaves exacly like a naive implementation': (q) ->
		nq = new NaivePriorityQueue()
		for op in (arbQueueOp() for _ in [1...100])
			nr = nq[op.op].apply(nq,op.args)
			qr =  q[op.op].apply(q,op.args)
			# console.log "#{op.op}(#{op.args ? ''}) -> (#{nr},#{qr})"
			@equals qr, nr

###
A litle readability helper
###
adaptCase = (impl) -> (test) ->
	impl.call test, new PQ()
	test.done()

adapt = (tests) ->
	adapted = {}
	for own desc, impl of tests
		adapted[desc] = adaptCase impl
	adapted

module.exports = adapt testCases
