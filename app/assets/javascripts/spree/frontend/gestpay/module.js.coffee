@SpreeGestpay = {}

class module
  check: (result, expected) =>
    parseInt(result.ErrorCode) == expected

  error: (string, result) =>
    @log("#{string}: '#{result.ErrorDescription}' (#{result.ErrorCode})")

  log: (string) ->
    @logger ||= new SpreeGestpay.logger(@gestpayModuleName())
    @logger.log(string)

  gestpayModuleName: ->
    undefined

SpreeGestpay.module = module
