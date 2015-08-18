module Gestpay
  class Gateway
    include Coders

    def initialize(args={})
      wsdl = Gestpay::Host.s2s/'gestpay/gestpayws/WSs2s.asmx?WSDL'
      args = { wsdl: wsdl, ssl_version: :TLSv1, :follow_redirects => true }.merge(args)
      @client = Gestpay::SoapClient.new(args)
    end

    def payment(data)
      data[:custom_info] = encode(data[:custom_info]) if data[:custom_info]
      response = @client.call(:call_pagam_s2_s, data)
      response_content = response.body[:call_pagam_s2_s_response][:call_pagam_s2_s_result][:gest_pay_s2_s]
      Result::Payment.new(response_content)
    end
  end
end
