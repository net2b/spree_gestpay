module Gestpay
  module Result
    class Digest < Gestpay::Result::Base
      def buyer_name
        buyer[:buyer_name]
      end

      def buyer_email
        buyer[:buyer_email]
      end

      def encrypted_string
        crypt_decrypt_string
      end
    end
  end
end
