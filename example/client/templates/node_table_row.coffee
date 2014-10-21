Template.nodeTableRow.helpers
  isSet: ->
    if @node.isSet() then 'Yes' else 'No'

  value: ->
    @node.get()

