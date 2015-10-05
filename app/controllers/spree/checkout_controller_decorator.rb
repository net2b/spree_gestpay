Spree::CheckoutController.class_eval do
  before_filter :redirect_to_gestpay_if_needed, only: [:update]

  private

  def redirect_to_gestpay_if_needed
    # This will be called during any update action, so we need to make sure we're at the right step
    return unless (params[:state] == "payment")
    # Checks that a form with payments attributes has been submitted
    return unless (params[:order] || {})[:payments_attributes]

    # Sets the instance variable
    payment_method = Spree::PaymentMethod.find(params[:order][:payments_attributes].first[:payment_method_id])
    return unless payment_method.respond_to?(:is_gestpay?) && payment_method.is_gestpay?

    process_gestpay_unlimited(payment_method)
  end

  def process_gestpay_unlimited(payment_method)
    account = nil

    unless check_for_cvv
      return redirect_to checkout_state_path(:payment), alert: t('cvv_not_correct')
    end

    if payment_method.can_tokenize?
      account = Spree::GestpayAccount.find(params[:account].to_i)
      return unless account.user == current_user
    end

    result = Gestpay::Token.new(payment_method.can_tokenize?) do |t|
      t.transaction = @order.number
      t.amount      = @order.total
      t.language    = gestpay_current_locale.to_s
      t.cvv         = params[:payment_source].first.last[:verification_value]
      t.token_value = account.token if account
      t.buyer_email = @order.email
      t.buyer_name  = @order.bill_address.full_name
    end.payment

    if result.success?
      payment = payment_method.process_payment_result(result)

      # Order completion routine
      @current_order = nil
      flash.notice = Spree.t(:order_processed_successfully)
      flash['order_completed'] = true
      return redirect_to completion_route
    elsif result.verify_by_visa?
      trans_key = result.transaction_key
      vbv       = result.visa_encrypted_string

      return redirect_to payment_method.url3d(secure_3d_callback_ws_url(@order), trans_key, vbv)
    else
      return redirect_to checkout_state_path(:payment), alert: result.error
    end
  end

  def check_for_cvv
    # TODO: refactor, find a more solid way to check cvv presence
    params[:payment_source].first.last[:verification_value].match(/\d{3,4}/)
  end

  def gestpay_current_locale
    # TODO: should be overwritten in histreet with current_locale
    I18n.locale
  end
end
