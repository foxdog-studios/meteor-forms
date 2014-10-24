'use strict'

class Pkg.CleanStringComputation extends Pkg.Computation
  checkArgs: (node, values, unset) ->
    _.isString values.string

  compute: (node, values, unset) ->
    values.string.trim()

