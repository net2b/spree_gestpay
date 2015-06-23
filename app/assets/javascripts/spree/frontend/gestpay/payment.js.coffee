class payment extends SpreeGestpay.module
  GESTPAY_NO_ERROR    = 0
  GESTPAY_NO_ERROR_3D = 8006

  callback: (result) =>
    if @check(result, GESTPAY_NO_ERROR)
      @log("result: #{result}")
      encriptedString = result.EncryptedString
      @log("performed authorization (encriptedString: #{encriptedString})")
      @log("translating response with an ajax call...")
      $.ajax
        type: "POST"
        url: '/checkout/payment/process_token.json'
        data:
          token: encriptedString
        dataType: "json"
      .done (response) =>
        token = response.token
        @log("payment is ok #{response.string}")
      .fail (response) =>
        json = $.parseJSON(response.responseText)
        @log("payment is failed - #{json.error}")
      return

    if @check(result, GESTPAY_NO_ERROR_3D)
      transKey = result.TransKey
      vbv      = result.VBVRisp
      @log("performed 3D authorization (transKey: #{transKey}, vbv: #{vbv})")
      # 3D call redirect to authentication page
      return

    @error("error during authorization", result)

  send: (options) =>
    GestPay.SendPayment(options, @callback)

  callback3d: (result) =>
    if @check(result, GESTPAY_NO_ERROR)
      response = result.EncryptedString
      @log("performed 3D authorization (response: #{response})")
      return

    @error("error during 3D authorization", result)

  send3d: (options) =>
    GestPay.SendPayment(options, @callback3d)

  gestpayModuleName: ->
    "payment"

SpreeGestpay.payment = payment
