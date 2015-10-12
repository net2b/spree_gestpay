module Spree
  # TODO: change this controller name or split it since not every actions
  # here come from iframe
  class GestpayIframeCallbacksController < Spree::BaseController
    include Spree::Core::ControllerHelpers::Order

    protect_from_forgery except: [:secure_3d, :secure_3d_ws]

    def secure_3d
      @pares     = params["PaRes"].gsub(/\s+/, "")
      @trans_key = params[:trans_key]
    end

    def secure_ko
      error = params[:error].blank? ? I18n.t(:generic_error, scope: :gestpay) : params[:error]
      redirect_to spree.checkout_state_url(:payment), flash: { error: error }
    end

    def secure_3d_ws
      order = Spree::Order.find_by_number(params[:order_number])
      payment_method = Spree::PaymentMethod.find_by_type('Spree::Gateway::Gestpay')

      result = Gestpay::Token.new do |t|
        t.language    = gestpay_current_locale.to_s
        t.transaction = order.number
        t.amount      = order.total
        t.trans_key   = params[:trans_key]
        t.pares       = params[:PaRes]
      end.payment

      if result.success?
        payment = payment_method.process_payment_result(result)

        if payment.try(:pending?)
          # Order completion routine
          @current_order = nil
          flash.notice = Spree.t(:order_processed_successfully)
          flash['order_completed'] = true
          return redirect_to spree.order_path(order)
        end
      end

      redirect_to spree.checkout_state_path(:payment), alert: result.error
    end

    private

    def gestpay_current_locale
      # TODO: should be overwritten in histreet with current_locale
      I18n.locale
    end
  end
end
