'use strict'

class Pkg.Computation
  onAfterInputChange: (node) ->

  checkArgs: (node, values, unset) ->
    _.isEmpty unset

  compute: (node, values, unset) ->
    values

  checkResult: (node, result) ->
    result?

  setResult: (node, result) ->
    node.set result

  onAbort: (node) ->
    node.unset()

