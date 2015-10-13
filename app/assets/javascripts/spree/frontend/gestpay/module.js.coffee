@SpreeGestpay = {}

class module
  constructor: ->
    @submitButton = $('#js-gestpay-submit-button')
    @errorDiv     = $('.js-gestpay-errors')
    @errorContent = $('.js-gestpay-error-message-content')

  createPage: ->
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
      koUrl       = $gestpay3d.data("ko-url")

      result3d = new SpreeGestpay.result3d(merchant, token, transKey, paRes, koUrl)
      result3d.generate()

      # We need to retrieve the result3D koUrl variable later.
      window.result3d = result3d

  destroyPage: ->
    @log('iframe destroyed')
    $('iframe#GestPay').remove()

  resetPage: ->
    @destroyPage()
    @createPage()

  disableSubmit: ->
    @submitButton.prop('disabled', true).val(@submitButton.data('inactive-text'))

  enableSubmit: ->
    @submitButton.prop('disabled', false).val(@submitButton.data('active-text'))

  check: (result, expected) =>
    parseInt(result.ErrorCode) == expected

  error: (string, result) =>
    logString = string
    htmlString = string

    if result
      logString += ": '#{result.ErrorDescription}' (#{result.ErrorCode})"
      htmlString = result.ErrorDescription

    @log(logString)
    @errorContent.html(htmlString)
    @errorDiv.show()

  log: (string) ->
    @logger ||= new SpreeGestpay.logger(@gestpayModuleName())
    @logger.log(string)

  gestpayModuleName: ->
    undefined

SpreeGestpay.module = module
