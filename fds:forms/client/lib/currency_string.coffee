'use strict'

class Forms.CurrencyString
  # Our own currency parse with detectable parsing errors.
  parser = Object.create Jison.Parsers.currency
  parser.yy = Object.create parser.yy
  errorTag = {}
  parser.yy.parseError = (str, hash) ->
    error = new Error str, hash
    error.tag = errorTag
    throw error

  constructor: (@sign, @pounds, @pence) ->

  toString: ->
    size = 3
    pounds = []

    head = @pounds.length % size
    if head > 0
      pounds.push @pounds[...head]
    for i in [head...@pounds.length] by size
      pounds.push @pounds[i...i + size]
    pounds = pounds.join ','

    [@sign, pounds, '.', @pence].join ''

  @tryFromString: (string) ->
    try
      parts = parser.parse string
    catch error
      throw error unless error.tag == errorTag
      return
    new this parts.sign, parts.pounds, parts.pence

