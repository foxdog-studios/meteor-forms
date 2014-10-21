'use strict'

Forms.Node = (options = {}) ->
  node = new Node
  if 'value' of options
    node.set options.value
  if 'inputs' of options
    for tag, input of options.inputs
      node.from input, tag
  node

class Node
  constructor: ->
    @_isSet = ReactiveVar false
    @_value = ReactiveVar()
    @_inputs = {}
    @_inputsDep = new Tracker.Dependency

  toString: ->
    parts = ['Node{', undefined, '}']
    parts[1] = '' + @get() if @isSet()
    parts.join ''

  isSet: => @_isSet.get()

  get: => @_value.get()

  set: (value) =>
    @_value.set value
    @_isSet.set true

  unset: =>
    @_isSet.set false
    @_value.set()

  inputs: (iteratee) =>
    @_inputsDep.depend()
    for tag, input of @_inputs
      iteratee input, tag
    return

  to: (node, tag) => node.from this, tag

  from: (node, tag) =>
    @_inputs[tag] = node
    @_inputsDep.changed()

