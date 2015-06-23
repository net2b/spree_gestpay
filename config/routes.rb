Spree::Core::Engine.routes.draw do
  post '/checkout/payment/get_token.json' => "gestpay#get_token",
      as: :gestpay_get_token

  post '/checkout/payment/process_token.json' => "gestpay#process_token",
      as: :gestpay_process_token

  get '/checkout/payment/gestpay_completion' => "gestpay#completion",
      as: :gestpay_completion

end
