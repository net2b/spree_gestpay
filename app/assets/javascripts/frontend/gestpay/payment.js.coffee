class payment extends SpreeGestpay.module
  GESTPAY_NO_ERROR    = 0
  GESTPAY_NO_ERROR_3D = 8006

  callback: (result) =>
    if check(result, GESTPAY_NO_ERROR)
      response = result.EncryptedResponse
      @log("performed authorization (response: #{response})")
      # normal call access Result.EncryptedResponse
      return

    if check(result, GESTPAY_NO_ERROR_3D)
      transKey = result.TransKey
      vbv      = result.VBVRisp
      @log("performed 3D authorization (transKey: #{transKey}, vbv: #{vbv})")
      # 3D call redirect to authentication page
      return

    @error("error during authorization", result)

  send: (options) =>
    GestPay.SendPayment(options, @callback)

  callback3d: (result) =>
    if check(result, GESTPAY_NO_ERROR)
      response = result.EncryptedResponse
      @log("performed 3D authorization (response: #{response})")
      return

    @error("error during 3D authorization", result)

  send3d: (options) =>
    GestPay.SendPayment(options, @callback3d)

  gestpayModuleName: ->
    "payment"

SpreeGestpay.payment = payment
