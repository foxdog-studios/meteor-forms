'use strict'

class Forms.DecimalString
  constructor: (@sign, @integer, @point, @fraction) ->

  _match: (string) ->
    string.match DECIMAL_REGEX

  toString: ->
    [@sign, @integer, @point, @fraction].join ''

  @fromString: (string) ->
    parts = Jison.Parsers.decimal.parse string
    new this parts.sign, parts.integer, parts.point, parts.fraction

