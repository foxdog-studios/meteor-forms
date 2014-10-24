Template.nodeTableRow.helpers
  isSet: ->
    if @isSet() then 'Yes' else 'No'

  value: ->
    @get()

