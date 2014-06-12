module Spree
  class GestpayController < StoreController
    def get_token
      result = Gestpay::Token.new.result
      if result.success?
        render json: { token: result.encrypted_string }
      else
        render json: { error: result.error }, status: 500
      end
    end
  end
end
