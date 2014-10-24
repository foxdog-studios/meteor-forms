'use strict'

Forms.NodeComputer = (node, nodeComputationClass) ->
  new NodeComputer node, nodeComputationClass

class NodeComputer
  constructor: (@_node, @_nodeComputationClass) ->
    @_computation = null

  start: =>
    if @_computation?
      throw new Error 'This node computer is already running.'
    @_computation = Tracker.autorun @_onInputChange

  stop: =>
    unless @_computation?
      throw new Error 'This node computer is already stopped.'
    @_computation.stop()
    @_computation = null

  _onInputChange: =>
    comp = new @_nodeComputationClass
    comp.onAfterInputChange()
    [values, unset] = @_makeComputeArgs()
    canContinue = comp.checkArgs @_node, values, unset
    if canContinue
      result = comp.compute @_node, values, unset
      canContinue = comp.checkResult @_node, result
      if canContinue
        comp.setResult @_node, result
    comp.onAbort @_node unless canContinue

  _makeComputeArgs: =>
    values = {}
    unset = []
    @_node.inputs (input, tag) ->
      if input.isSet()
        values[tag] = input.get()
      else
        unset.push tag
    [values, unset]

