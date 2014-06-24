module ViewStubsHelpers
  def use_js_stubs(*list)
    list = list.map {|j| "store/gestpay/stubs/#{j}.js"}
    instance = allow_any_instance_of(Spree::GestpayHelper)
    instance.to receive(:gestpay_stub_scripts_list).and_return(list)
  end
end
