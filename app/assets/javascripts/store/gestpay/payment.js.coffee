class payment
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

    @error("error during credit card authorization", result)

  send: (options) =>
    GestPay.SendPayment(options, @callback)

SpreeGestpay.payment
