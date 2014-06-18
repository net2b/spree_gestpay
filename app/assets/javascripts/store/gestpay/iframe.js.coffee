class iframe
  constructor: (@merchant, @tokenPath, @transaction, @amount) ->

  generate: ->
    # Probably not on the correct page
    if @browserSupported()
      @log("GESTPAY: iframe initialized")
      @getToken()
    else
      @log("GESTPAY: browser not supported")

  browserSupported: ->
    # This variable is set on window directly by the initialization script of
    # Gestpay. If it evaluates to false the browser is not supported.

    # Not sure why it's not exposed on the Gestpay object, they must love to
    # pollute my window.
    window.BrowserEnabled

  getToken: ->
    $.ajax
      type: "POST"
      url:  @tokenPath
      data:
        transaction: @transaction
        amount:      @amount
      dataType: "json"
    .done (response) =>
      token = response.token
      @log("GESTPAY: getToken success - #{token}")
      @createPaymentPage(token)
    .fail (response) =>
      json = $.parseJSON(response.responseText)
      @log("GESTPAY: getToken failure - #{json.error}")

  createPaymentPage: (token) ->
    GestPay.CreatePaymentPage(@merchant, token, @paymentPageLoaded)

  # Magic _fucking_ numbers, next time define them on your fucking Gestpay
  # object you pollute my window namespace with
  GESTPAY_NO_ERROR = 10

  # Used as a callback, we need to use a fat arrow to keep this pointing to
  # our current instance
  paymentPageLoaded: (result) =>
    # Gestpay returns error codes as strings. Convert them to integers before
    # comparing them
    if parseInt(result.ErrorCode) == GESTPAY_NO_ERROR
      @log("GESTPAY: iframe loaded!")
    else
      @log("GESTPAY: error loading iframe: '#{result.ErrorDescription}'
      (#{result.ErrorCode})")

  log: (string) ->
    console.log && console.log(string)

$ ->
  $gestpay = $(".gestpay-data")
  if $gestpay.length > 0
    merchant    = $gestpay.data("merchant")
    transaction = $gestpay.data("transaction")
    amount      = $gestpay.data("amount")
    tokenPath   = $gestpay.data("token-path")
    new iframe(merchant, tokenPath, transaction, amount).generate()
