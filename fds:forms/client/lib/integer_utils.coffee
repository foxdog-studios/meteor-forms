'use strict'

Pkg.IntegerUtils =
  tryParseSafeInteger: (value) ->
    str = String value

    match = ///
      ^          # The entire string must match
        \s*      # The number may have leading whitespace
        [-+]?    # The number may be signed
        0*       # The number may have leading zeros
        (\d+)    # The number must contain at least one digit
        (\.0*)?  # The number may have a fraction part equal to zero
        \s*      # The number may have trailing whitespace
      $
    ///.exec str

    return null unless match

    numerals = match[1]
    limitNumerals = String Math.pow 2, 53

    # As numerals and limitNumerals only contain the numerals 0 to 9, if
    # they are the same length, a lexicographic comparison is equivalent
    # to the numeric comparison of the corresponding numbers.
    if numerals.length > limitNumerals.length or \
       numerals.length == limitNumerals.length and numerals > limitNumerals
      return null

    parseInt str, 10

