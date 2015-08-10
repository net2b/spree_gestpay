Spree::Core::Engine.routes.draw do
  post '/checkout/payment/get_token.json' => "gestpay#get_token",
      as: :gestpay_get_token

  post '/checkout/payment/process_token.json' => "gestpay#process_token",
      as: :gestpay_process_token

  post '/checkout/payment/process_3d_redirect.json' => "gestpay#process_3d_redirect",
      as: :gestpay_3d_redirect

  post '/checkout/payment/process_3d_redirect.json' => "gestpay#process_3d_redirect",
      as: :gestpay_3d_ko_redirect

  get '/checkout/payment/gestpay_completion/:order_number' => "gestpay#completion",
      as: :gestpay_completion

  match '/gestpay_iframe_secure_3d'    => 'gestpay_iframe_callbacks#secure_3d', via: [:post, :get], as: :secure_3d_callback
  match '/gestpay_iframe_secure_3d_ko' => 'gestpay_iframe_callbacks#secure_ko', via: :get,          as: :secure_3d_ko_callback
end
