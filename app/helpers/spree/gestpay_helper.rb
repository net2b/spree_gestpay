module Spree::GestpayHelper
  def gestpay_iframe_script
    attrs =  {
      src:  Gestpay::Host.c2s/'pagam/JavaScript/js_GestPay.js',
      type: "text/javascript"
    }
    javascript_tag nil, attrs
  end

  def gestpay_stub_scripts
    raw gestpay_stub_scripts_list.map { |stub|
      javascript_tag nil, src: asset_path(stub), type: "text/javascript"
    }.join
  end

  def gestpay_stub_scripts_list
    []
  end

  def gestpay_merchant
    Gestpay.config.account
  end
end
