module Gestpay
  class Config
    attr_accessor :environment, :account

    def initialize
      @environment = Rails.env.production? ? :production : :test
      @account     = Spree::PaymentMethod.find_by_type('Spree::Gateway::Gestpay').preferred_merchant_id || ENV['GESTPAY_ACCOUNT']
    end
  end
end
