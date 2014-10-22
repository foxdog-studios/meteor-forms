'use strict'

class Forms.CurrencyString
  constructor: (@sign, @pounds, @pence) ->

  toString: ->
    [@sign, @pounds, '.', @pence].join ''

  @fromString: (string) ->
    try
      parts = Jison.Parsers.currency.parse string
    catch
      return
    new this parts.sign, parts.pounds, parts.pence

