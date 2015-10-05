module Spree
  class Gateway::Gestpay < Gateway
    preference :merchant_id, :string
    preference :tokenization, :boolean, default: false

    def supports?(source)
      true
    end

    def auto_capture?
      false
    end

    def method_type
      # used to display gestpay payment partial
      'gestpay'
    end

    def is_gestpay?
      true
    end

    def provider_class
      provider.class
    end

    def provider
      self
    end

    def actions
      %w(capture void)
    end

    def can_tokenize?
      preferred_tokenization
    end

    # Indicates whether its possible to capture the payment
    def can_capture?(payment)
      ['pending'].include?(payment.state)
    end

    # Indicates whether its possible to void the payment.
    def can_void?(payment)
      payment.state != 'void'
    end

    def can_authorize?(payment)
      ['checkout', 'pending'].include?(payment.state)
    end
    #######################################################################

    def capture(*_args)
      ActiveMerchant::Billing::Response.new(true, '', {}, {})
    end

    def void(*_args)
      ActiveMerchant::Billing::Response.new(true, '', {}, {})
    end

    def authorize(*_args)
      ActiveMerchant::Billing::Response.new(true, '', {}, {})
    end

    def cancel(response_code)
      ActiveMerchant::Billing::Response.new(
        true,
        Spree.t('global_collect.payment_canceled')
      )
    end

    def url3d(secure_3d_callback_url, trans_key, vbv)
      account      = ::Gestpay.config.account
      url3d        = ::Gestpay::Host.c2s/'pagam/pagam3d.aspx'
      callback_url = CGI::escape("#{secure_3d_callback_url}?trans_key=#{trans_key}")

      "#{url3d}?a=#{account}&b=#{vbv}&c=#{callback_url}"
    end

    def process_payment_result(result)
      Rails.logger.warn "Gestpay Result: #{result.inspect}"
      order = Spree::Order.find_by_number(result.shop_transaction_id)
      Rails.logger.warn "Processing payment results for order id #{ order.id }: #{ order.state } | #{ order.number }"

      # TODO: Add a transaction?
      # Spree::Order.transaction do ... end

      # this check is needed because this method is called twice during the iframe checkout process
      if order.state == 'complete'
        return order.payments.last
      end

      if order.state == 'payment'
        # Account used as source of the payment. By default it is the
        # payment gateway itself. If an user is associated to the order
        # it will use the GestpayAccount associated.
        account = self
        # try will not raise in Rails 4 if the 'token' method does not exists. Rails 3 will.
        # result will not respond_to token, so we have to skip this check.
        begin
          if result.token.present?
            if user = order.user
              account = Spree::GestpayAccount.new
              account.user = user
              account.token = result.token
              account.month = result.token_expiry_month
              account.year = result.token_expiry_year
              account.save

              Rails.logger.warn "GestPay Account saved #{ account.id }"
            end
          end
        rescue => e
          Rails.logger.warn 'GestPay token not valid, skipping saving account'
        end

        payment = order.payments.create(
          amount: result.amount,
          payment_method_id: id
        )
        payment.source = account

        Rails.logger.warn "Processing payment #{ payment.id }"
        Rails.logger.warn "Updating order state: from #{order.state}"

        if result.success?
          order.next
          Rails.logger.warn "Updating order state: to #{order.state}"
          Rails.logger.warn "Updating order state: finalized: #{order.state}"
        else
          payment.started_processing!
          payment.failure!
        end

        Rails.logger.warn "Payment processed #{ payment.id } (#{ payment.state }) for order #{ payment.order.number } (#{payment.order.state})"

        return payment
      end
    end

    def reusable_sources(order)
      if order.completed?
        sources_by_order order
      else
        if order.user_id
          order.user.gestpay_accounts
        else
          []
        end
      end
    end
  end
end
