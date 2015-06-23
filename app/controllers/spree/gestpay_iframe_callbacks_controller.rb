module Spree
  class GestpayIframeCallbacksController < Spree::BaseController
    protect_from_forgery except: [:secure_3d]
    layout false

    def secure_3d
      # Not sure why opts is needed
      opts = {}
      if Settings.sella.buyer_email
        opts[:buyer_email] = Settings.sella.buyer_email
        Rails.logger.info "Using a custom buyer_email: #{opts[:buyer_email]}"
      end
      # it = 1, en = 2, es = 3, fr = 4, de = 5
      opts[:language_id] = (%w{ it en es fr de }.index(I18n.locale.to_s) || 1) + 1

      @order = current_order
      result = Spree::PaymentMethod.find(5).get_token(@order, opts)
      if result.success?
        session[:token] = result.encrypted_string
      else
        redirect_to cart_path, alert: result.error
      end
    end
  end
end
