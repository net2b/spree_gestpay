@SpreeGestpay = {}

class module
  constructor: ->
    @submitButton = $('#js-gestpay-submit-button')

  check: (result, expected) =>
    parseInt(result.ErrorCode) == expected

  error: (string, result) =>
    @log("#{string}: '#{result.ErrorDescription}' (#{result.ErrorCode})")

  log: (string) ->
    @logger ||= new SpreeGestpay.logger(@gestpayModuleName())
    @logger.log(string)

  gestpayModuleName: ->
    undefined

  disableSubmit: ->
    @submitButton.prop('disabled', true).val(@submitButton.data('inactive-text'))

  enableSubmit: ->
    @submitButton.prop('disabled', false).val(@submitButton.data('active-text'))

SpreeGestpay.module = module
