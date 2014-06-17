Spree::Core::Engine.routes.draw do
  post '/checkout/payment/get_token.json' => "gestpay#get_token",
      as: :gestpay_get_token
end
