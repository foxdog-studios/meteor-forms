'use strict'

class Forms.CurrencyGraph
  constructor: ->
    @raw = Pkg.ComputationNode new Forms.Node(), Pkg.NullNodeComputer()

    chain = (compClass, inputName, node) ->
      options = inputs: {}
      options.inputs[inputName] = node
      node = new Forms.Node options
      comp = new Forms.NodeComputer node, compClass
      Pkg.ComputationNode node, comp

    @string   = chain Pkg.StringComputation        , 'value'   , @raw
    @clean    = chain Pkg.CleanStringComputation   , 'string'  , @string
    @currency = chain Pkg.CurrencyStringComputation, 'string'  , @clean
    @pence    = chain Pkg.PenceComputation         , 'currency', @currency

    @_nodes = [
      @raw
      @string
      @clean
      @currency
      @pence
    ]

  start: ->
    node.start() for node in @_nodes
    return

  stop: ->
    node.stop() for node in @_nodes
    return

