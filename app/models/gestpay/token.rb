module Gestpay
  class Token
    class Builder < Struct.new(
      :shop_login, :buyer_email, :buyer_name, :amount, :shop_transaction_id,
      :uic_code, :language_id, :token_value, :request_token)

      def language=(language)
        self.language_id = language.code
      end

      def currency=(currency)
        self.uic_code = currency.code
      end

      def transaction=(tx)
        self.shop_transaction_id = tx
      end

      def to_h
        super.delete_if { |k, v| v.nil? }
      end
    end

    def initialize
      @options = Builder.new
      @options.request_token = "MASKEDPAN"
      @options.language      = Language.default
      @options.currency      = Currency.default
      @options.shop_login    = Gestpay.config.account
      yield(@options) if block_given?
    end

    def [](key)
      @options.to_h[key]
    end

    def encrypted_string
      result.encrypted_string
    end

    def result
      @token ||= Gestpay::Digest.new.encrypt(@options.to_h)
    end
  end
end
