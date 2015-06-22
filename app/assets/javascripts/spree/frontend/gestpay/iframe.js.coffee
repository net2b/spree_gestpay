class form
  cardNumber: ->
    @get 'card_number'

  cardExpiration: ->
    month: @get 'card_month'
    year:  @get 'card_year'

  cardSecureCode: ->
    @get 'card_code'

  get: (id) ->
    $("##{id}").val()

class iframe extends SpreeGestpay.module
  constructor: (@merchant, @tokenPath, @transaction, @amount) ->

  generate: ->
    if @browserSupported()
      @log("iframe initialized")
      @getToken()
    else
      @log("browser not supported")

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
      @log("getToken success - #{token}")
      @createPaymentPage(token)
    .fail (response) =>
      json = $.parseJSON(response.responseText)
      @log("getToken failure - #{json.error}")

  createPaymentPage: (token) ->
    GestPay.CreatePaymentPage(@merchant, token, @paymentPageLoaded)

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
      @registerSendPayment()
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
    "iframe"

@SpreeGestpay.iframe = iframe
