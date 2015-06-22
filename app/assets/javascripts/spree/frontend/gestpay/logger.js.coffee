class logger
  constructor: (@module) ->

  log: (string) ->
    console.log && console.log("[gestpay][#{@module}]: #{string}")

@SpreeGestpay.logger = logger
