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


class CurrencyStringComputation extends Forms.NodeComputation
  checkArgs: (node, values, unset) ->
    _.isString values.string

  compute: (node, values, unset) ->
    Forms.CurrencyString.fromString values.string


class PenceComputation extends Forms.NodeComputation
  compute: (node, values, unset) ->
    currency = values.currency
    pounds = @_makePounds currency.pounds
    pence = @_makePence currency.pence
    total = pounds + pence
    if currency.sign == '-'
      total = -total
    total

  _makePounds: (pounds) ->
    100 * parseInt pounds, 10

  _makePence: (pence) ->
    parseInt pence, 10


class FormBehaviour extends FDS.Behaviour
  init: ->
    @_raw = makeRawNode()
    @_string = makeStringNode @_raw.node
    @_clean = makeCleanNode @_string.node
    @_currency = makeCurrencyStringNode @_clean.node
    @_pence = makePenceNode @_currency.node

  getNodes: -> [
    @_raw
    @_string
    @_clean
    @_currency
    @_pence
  ]

  onInputBur: (event, instance) ->
    node = if @_currency.node.isSet() then @_currency else @_clean
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


makeCurrencyStringNode = (stringNode) ->
  node = Forms.Node inputs: string: stringNode
  comp = Forms.NodeComputer node, CurrencyStringComputation
  comp.start()
  name: 'Currency'
  node: node
  comp: comp


makePenceNode = (currencyNode) ->
  node = Forms.Node inputs: currency: currencyNode
  comp = Forms.NodeComputer node, PenceComputation
  comp.start()
  name: 'Pence'
  node: node
  comp: comp

