class Pkg.PenceComputation extends Pkg.Computation
  compute: (node, values, unset) ->
    currency = values.currency
    pence = "#{ currency.sign }#{ currency.pounds }#{ currency.pence }"
    pence = Pkg.IntegerUtils.tryParseSafeInteger pence
    pence if pence?

