module Spree::GestpayHelper
  def gestpay_iframe_script
    attrs =  {
      src:  Gestpay::Host.c2s/'pagam/JavaScript/js_GestPay.js',
      type: "text/javascript"
    }
    content_tag(:script, nil, attrs)
  end
end
