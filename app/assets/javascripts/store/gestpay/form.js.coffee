class form
  paymentCallback: =>
    @log('performed payment')

  addSubmitEventHandler: ->

  log: (string) ->
    @logger ||= new SpreeGestpay.logger("form")
    @logger.log(string)

