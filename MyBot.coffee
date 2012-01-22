CONFIG = require('./ants').CONFIG
ants = require('./ants').Game

directions = ['N', 'E', 'S', 'W']

class Bot
  # You can setup stuff here, before the first turn starts:
  ready: ->

  # Here are the orders to the ants, executed each turn:
  do_turn: -> 
    for ant in ants.my_ants()
      for dir in directions
        if ant.can_move dir
          ant.move dir
          break

ants.run new Bot()
