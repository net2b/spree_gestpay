module Spree
  class GestpayIframeCallbacksController < Spree::BaseController
    include Spree::Core::ControllerHelpers::Order

    protect_from_forgery except: [:secure_3d]

    def secure_3d
      @pares     = params["PaRes"].gsub(/\s+/, "")
      @trans_key = params[:trans_key]
    end
  end
end
