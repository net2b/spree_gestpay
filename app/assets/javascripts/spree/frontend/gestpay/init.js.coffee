$ ->
  $gestpay = $(".gestpay-data")
  if $gestpay.length > 0
    merchant    = $gestpay.data("merchant")
    transaction = $gestpay.data("transaction")
    amount      = $gestpay.data("amount")
    tokenPath   = $gestpay.data("token-path")
    new SpreeGestpay.iframe(merchant, tokenPath, transaction, amount).generate()
