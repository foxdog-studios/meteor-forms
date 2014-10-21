'use strict'


class Forms.NodeComputation
  onAfterInputChange: (node) ->

  checkArgs: (node, values, unset) ->
    true

  compute: (node, values, unset) ->
    values

  checkResult: (node, result) ->
    result?

  onAfterCompute: (node, result) ->
    node.set result

  onAbort: (node) ->
    node.unset()

