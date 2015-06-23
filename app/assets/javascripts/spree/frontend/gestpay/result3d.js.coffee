class result3d extends SpreeGestpay.module
  constructor: (@merchant, @token) ->

  generate: ->
    if @browserSupported()
      @log("iframe initialized")
      @createPaymentPage()
    else
      @log("browser not supported")

  browserSupported: ->
    # This variable is set on window directly by the initialization script of
    # Gestpay. If it evaluates to false the browser is not supported.

    # Not sure why it's not exposed on the Gestpay object, they must love to
    # pollute my window.
    window.BrowserEnabled

  createPaymentPage: (token) ->
    GestPay.CreatePaymentPage(@merchant, @token, @paymentPageLoaded)

  # Magic _fucking_ numbers, next time define them on your fucking Gestpay
  # object you pollute my window namespace with
  GESTPAY_LOAD_NO_ERROR = 10

  # Used as a callback, we need to use a fat arrow to keep this pointing to
  # our current instance
  paymentPageLoaded: (result) =>
    # Gestpay returns error codes as strings. Convert them to integers before
    # comparing them
    if @check(result, GESTPAY_LOAD_NO_ERROR)
      @log("iframe loaded!")
      payment = new SpreeGestpay.payment()
      payment.send3d()
    else
      @error("error loading iframe", result)

  registerSendPayment: =>
    $('input[type=submit].continue').on 'click', (e) =>
      e.preventDefault()
      f = new form()

      payment = new SpreeGestpay.payment()
      payment.send
        CC:    f.cardNumber()
        EXPMM: f.cardExpiration().month
        EXPYY: f.cardExpiration().year
        CVV2:  f.cardSecureCode()

  gestpayModuleName: ->
    "result3d"

@SpreeGestpay.iframe = iframe
