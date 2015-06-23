$ ->
  $gestpay = $(".gestpay-data")
  if $gestpay.length > 0
    merchant    = $gestpay.data("merchant")
    transaction = $gestpay.data("transaction")
    amount      = $gestpay.data("amount")
    tokenPath   = $gestpay.data("token-path")
    new SpreeGestpay.iframe(merchant, tokenPath, transaction, amount).generate()

  $gestpay3d = $(".gestpay-data-3d")
  if $gestpay3d.length > 0
    merchant    = $gestpay3d.data("merchant")
    token       = $gestpay3d.data("token")
    transKey    = $gestpay3d.data("transkey")
    paRes       = $gestpay3d.data("pares")
    new SpreeGestpay.result3d(merchant, token, transKey, paRes).generate()
