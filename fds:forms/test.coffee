addSafeIntegerTests = (schema) ->
  for [arg, isSafe, message] in schema
    addSafeIntegerTest arg, isSafe, message

addSafeIntegerTest = (arg, isSafe, message) ->
  funcName = if isSafe then 'isTrue' else 'isFalse'
  Tinytest.add "IntegerUtils.isSafe(#{ arg }) #{ message }", (test) ->
    test[funcName] Forms.IntegerUtils.isSafe(arg), message

addSafeIntegerTests [
  [                 '0', true , 'Positive zero'                   ]
  [                '-0', true , 'Negative zero'                   ]
  [  '9007199254740992', true , 'Greatest safe integer'           ]
  [ '-9007199254740992', true , 'Least safe integer'              ]
  [  '9007199254740993', false, 'Least positive unsafe integer'   ]
  [ '-9007199254740993', false, 'Greatest negative unsafe integer']
]

