class form
  cardNumber: ->
    @get 'card_number'

  cardExpiration: ->
    month: if @get('card_month').length == 1 then "0" + @get('card_month') else @get('card_month')
    year: @get('card_year').toString().substr(2,2);

  cardSecureCode: ->
    @get 'card_code'

  account: ->
    @get 'account'

  submit: ->
    $('#js-gestpay-form').trigger('submit')

  get: (id) ->
    $("##{id}").val()

class iframe extends SpreeGestpay.module
  constructor: (@merchant, @tokenPath, @transaction, @amount) ->
    super()

  generate: ->
    if @browserSupported()
      @log("iframe initialized")
      @getToken()
      @disableSubmit()
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
      @enableSubmit()
      @registerSendPayment()
    else
      @error("error loading iframe", result)

  registerSendPayment: =>
    @submitButton.on 'click', (e) =>
      @disableSubmit()
      e.preventDefault()
      f = new form()
      if f.account()
        f.submit()
      else
        payment = new SpreeGestpay.payment()
        payment.send
          CC:    f.cardNumber()
          EXPMM: f.cardExpiration().month
          EXPYY: f.cardExpiration().year
          CVV2:  f.cardSecureCode()

  gestpayModuleName: ->
    "iframe"

@SpreeGestpay.iframe = iframe
