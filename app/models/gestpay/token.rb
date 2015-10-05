module Gestpay
  class Token
    class Builder < Struct.new(
      :shop_login, :buyer_email, :buyer_name, :amount, :shop_transaction_id,
      :uic_code, :language_id, :token_value, :request_token, :cvv, :trans_key,
      :pares)

      def language=(language)
        self.language_id = Language.new(language).code
      end

      def currency=(currency)
        self.uic_code = currency.code
      end

      def transaction=(tx)
        self.shop_transaction_id = tx
      end

      def to_h
        hash = super.delete_if { |k, v| v.nil? }

        # pares key needs to be passed as string
        hash['PARes'] = hash.delete(:pares) if hash.key?(:pares)

        hash
      end

      def delete(key)
        value = self[key]
        self[key] = nil
        value
      end
    end

    def initialize(tokenization_enabled = nil)
      @options = Builder.new
      @options.request_token = "MASKEDPAN" if tokenization_enabled
      @options.language      = Language.default
      @options.currency      = Currency.default
      @options.shop_login    = Gestpay.config.account
      yield(@options) if block_given?

      # Since Gestpay actually authorize (without settle) money on real
      # credit cards in test environment, it's better to always use 0.1
      # as payment amount.
      @options.amount = 0.1 if Rails.env.development?
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

    def payment
      # When passing the token_value we need to remove request_token option
      @options.delete(:request_token) if @options.token_value.present?

      @payment ||= Gestpay::Gateway.new.payment(@options.to_h)
    end
  end
end
