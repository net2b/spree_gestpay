@SpreeGestpay = {}

class module
  constructor: ->
    @submitButton = $('#js-gestpay-submit-button')
    @errorDiv     = $('#js-gestpay-errors')

  disableSubmit: ->
    @submitButton.prop('disabled', true).val(@submitButton.data('inactive-text'))
    @errorDiv.hide()

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
    @errorDiv.html(htmlString).show()

  log: (string) ->
    @logger ||= new SpreeGestpay.logger(@gestpayModuleName())
    @logger.log(string)

  gestpayModuleName: ->
    undefined

SpreeGestpay.module = module
