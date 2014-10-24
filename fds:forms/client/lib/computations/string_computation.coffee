'use strict'

class Pkg.StringComputation extends Pkg.Computation
  checkArgs: (node, values, unset) ->
    _.isString values.value

  compute: (node, values, unset) ->
    values.value

