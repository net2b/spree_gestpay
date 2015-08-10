module Spree
  class GestpayIframeCallbacksController < Spree::BaseController
    include Spree::Core::ControllerHelpers::Order

    protect_from_forgery except: [:secure_3d]

    def secure_3d
      @pares     = params["PaRes"].gsub(/\s+/, "")
      @trans_key = params[:trans_key]
    end

    def secure_ko
      redirect_to spree.checkout_state_url(:payment), flash: { error: I18n.t(:generic_error, scope: :gestpay) }
    end
  end
end
