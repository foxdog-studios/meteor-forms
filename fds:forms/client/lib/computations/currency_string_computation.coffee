'use strict'

class Pkg.CurrencyStringComputation extends Pkg.Computation
  checkArgs: (node, values, unset) ->
    _.isString values.string

  compute: (node, values, unset) ->
    Forms.CurrencyString.tryFromString values.string

