module Spree
  class GestpayController < StoreController
    def get_token
      amount = if Rails.env.development?
        '0.1'
      else
        params[:amount]
      end

      result = Gestpay::Token.new do |t|
        t.transaction = params[:transaction]
        t.amount      = amount
      end.result

      if result.success?
        render json: { token: result.encrypted_string }
      else
        render json: { error: result.error }, status: 500
      end
    end

    def process_token
      result = Gestpay::Digest.new.decrypt(params[:token])

      if result.success?
        payment_method = Spree::PaymentMethod.find(params[:payment_method_id])
        payment = payment_method.process_payment_result(result)

        render json: { token: result.data, redirect: gestpay_completion_path }
      else
        render json: { error: result.error }, status: 500
      end
    end

    def process_3d_redirect
      payment_method = Spree::PaymentMethod.find(params[:payment_method_id])
      trans_key       = params[:trans_key]
      vbv            = params[:vbv]

      url3d = payment_method.url3d(secure_3d_callback_url, trans_key, vbv)

      render json: { redirect: url3d }
    end

    def completion
      order = current_order
      session[:order_id] = nil
      redirect_to order_path(order), notice: 'Order successful'
    end
  end
end
