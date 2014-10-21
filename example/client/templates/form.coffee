class StringComputation extends Forms.NodeComputation
  checkArgs: (node, values, unset) ->
    _.isString values.value

  compute: (node, values, unset) ->
    values.value


class CleanStringComputation extends Forms.NodeComputation
  checkArgs: (node, values, unset) ->
    _.isString values.string

  compute: (node, values, unset) ->
    values.string.trim()


class DecimalStringComputation extends Forms.NodeComputation
  checkArgs: (node, values, unset) ->
    _.isString values.string

  compute: (node, values, unset) ->
    try
      Forms.DecimalString.fromString values.string
    catch


class PenceComputation extends Forms.NodeComputation
  checkArgs: (node, values, unset) ->
    values.decimal?.fraction.length <= 2

  compute: (node, values, unset) ->
    decimal = values.decimal
    pounds = @_makePounds decimal.integer
    pence = @_makePence decimal.fraction
    total = pounds + pence
    if decimal.sign == '-'
      total = -total
    total

  _makePounds: (integer) ->
    100 * parseInt integer, 10

  _makePence: (fraction) ->
    while fraction.length < 2
      fraction += '0'
    parseInt fraction, 10


class FormBehaviour extends FDS.Behaviour
  init: ->
    @_raw = makeRawNode()
    @_string = makeStringNode @_raw.node
    @_clean = makeCleanNode @_string.node
    @_decimal = makeDecimalStringNode @_clean.node
    @_pence = makePenceNode @_decimal.node

  getNodes: -> [
    @_raw
    @_string
    @_clean
    @_decimal
    @_pence
  ]

  onInputBur: (event, instance) ->
    node = if @_decimal.node.isSet() then @_decimal else @_clean
    event.target.value = node.node.get()

  onValueChange: (event, instance) ->
    @_raw.node.set event.target.value


class FormBehaviourFactory extends FDS.AbstractBehaviourFactory
  create: (instance) ->
    behaviour = new FormBehaviour
    behaviour.init()
    behaviour

  helpers:
    'nodes': 'getNodes'

  events:
    'blur #value': 'onInputBur'
    'change #value, input #value': 'onValueChange'


FormBehaviourFactory.attach 'form'


makeRawNode = ->
  name: 'Raw'
  node: Forms.Node()
  comp: null


makeStringNode = (rawNode) ->
  node = Forms.Node inputs: value: rawNode
  comp = Forms.NodeComputer node, StringComputation
  comp.start()
  name: 'String'
  node: node
  comp: comp


makeCleanNode = (stringNode) ->
  node = Forms.Node inputs: string: stringNode
  comp = Forms.NodeComputer node, CleanStringComputation
  comp.start()
  name: 'Clean'
  node: node
  comp: comp


makeDecimalStringNode = (stringNode) ->
  node = Forms.Node inputs: string: stringNode
  comp = Forms.NodeComputer node, DecimalStringComputation
  comp.start()
  name: 'Decimal'
  node: node
  comp: comp


makePenceNode = (decimalNode) ->
  node = Forms.Node inputs: decimal: decimalNode
  comp = Forms.NodeComputer node, PenceComputation
  comp.start()
  name: 'Pence'
  node: node
  comp: comp

