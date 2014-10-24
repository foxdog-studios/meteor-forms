'use strict'

Pkg.ComputationNode = (node, computation) ->
  new ComputationNode node, computation

class ComputationNode
  constructor: (@_node, @_computation) ->
  start: -> @_computation.start()
  stop:  -> @_computation.stop()
  isSet: -> @_node.isSet()
  get:   -> @_node.get()
  set:   (value) -> @_node.set value

