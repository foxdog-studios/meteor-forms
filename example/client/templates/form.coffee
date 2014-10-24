class FormBehaviour extends FDS.Behaviour
  init: ->
    @_field = new Forms.CurrencyGraph
    @_field.raw.name = 'Raw'
    @_field.string.name = 'String'
    @_field.clean.name = 'Clean'
    @_field.currency.name = 'Currency'
    @_field.pence.name = 'Pence'

    @nodes = [
      @_field.raw
      @_field.string
      @_field.clean
      @_field.currency
      @_field.pence
    ]

  rendered: ->
    @_field.start()

  destroyed: ->
    @_field.stop()

  onInputBur: (event, instance) ->
    value = if @_field.currency.isSet()
      @_field.currency.get()
    else if @_field.clean.isSet()
      @_field.clean.get()
    else if @_field.string.isSet()
      @_field.string.get()
    event.target.value = value if value?

  onValueChange: (event, instance) ->
    @_field.raw.set event.target.value


class FormBehaviourFactory extends FDS.AbstractBehaviourFactory
  create: (instance) ->
    behaviour = new FormBehaviour
    behaviour.init()
    behaviour

  helpers:
    'nodes': 'nodes'

  events:
    'blur #value': 'onInputBur'
    'change #value, input #value': 'onValueChange'


FormBehaviourFactory.attach 'form'

