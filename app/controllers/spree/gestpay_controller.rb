module Spree
  class GestpayController < StoreController
    def get_token
      result = Gestpay::Token.new do |t|
        t.transaction = params[:transaction]
        t.amount      = params[:amount]
      end.result

      if result.success?
        session[:token] = result.encrypted_string
        render json: { token: result.encrypted_string }
      else
        render json: { error: result.error }, status: 500
      end
    end

    def process_token
      result = Gestpay::Digest.new.decrypt(params[:token])

      if result.success?
        payment_method = Spree::PaymentMethod.find_by_type('Spree::Gateway::Gestpay')
        payment = payment_method.process_payment_result(result)

        render json: { token: result.data, redirect: gestpay_completion_path(@current_order.number) }
      else
        render json: { error: result.error }, status: 500
      end
    end

    def process_3d_redirect
      payment_method = Spree::PaymentMethod.find_by_type('Spree::Gateway::Gestpay')
      trans_key      = params[:trans_key]
      vbv            = params[:vbv]

      url3d = payment_method.url3d(secure_3d_callback_url, trans_key, vbv)

      render json: { redirect: url3d }
    end

    def completion
      @current_order = nil

      if order = Spree::Order.find_by_number(params[:order_number])
        flash.notice = Spree.t(:order_processed_successfully)
        flash['order_completed'] = true # Useful to trigger marketing conversions
        redirect_to spree.order_path(order)
      else
        redirect_to spree.root_path
      end
    end
  end
end
