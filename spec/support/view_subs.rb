module ViewStubsHelpers
  def use_js_stubs(*list)
    list = list.map {|j| "store/gestpay/stubs/#{j}.js"}
    Spree::GestpayHelper.send(:define_method, :gestpay_stub_scripts_list) { list }
  end
end
