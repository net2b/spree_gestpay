class result3d extends SpreeGestpay.module
  constructor: (@merchant, @token, @transKey, @paRes) ->

  # This is called after a 3D Secure Code page redirects back user to our
  # website. We expect another payment to be created with 3D Secure Code
  # information.
  generate: ->
    if @browserSupported()
      @log("iframe initialized")
      @log(@merchant)
      @log(@token)
      @log(@transKey)
      @log(@paRes)
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
      payment.send3d
        'TransKey': @transKey.toString()
        'PARes':    @paRes
    else
      @error("error loading iframe", result)

  gestpayModuleName: ->
    "result3d"

@SpreeGestpay.result3d = result3d
