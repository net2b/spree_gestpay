module Gestpay
  class Digest
    include Coders

    def initialize(args={})
      wsdl = Gestpay::Host.s2s/'gestpay/gestpayws/WSCryptDecrypt.asmx?WSDL'
      args = { wsdl: wsdl, ssl_version: :TLSv1, :follow_redirects => true }.merge(args)
      @client = Gestpay::SoapClient.new(args)
    end

    def encrypt(data)
      data[:custom_info] = encode(data[:custom_info]) if data[:custom_info]
      response = @client.call(:encrypt, data)
      response_content = response.body[:encrypt_response][:encrypt_result][:gest_pay_crypt_decrypt]
      Result::Digest.new(response_content)
    end

    def decrypt(string)
      response = @client.call(:decrypt, {'CryptedString' => string})
      response_content = response.body[:decrypt_response][:decrypt_result][:gest_pay_crypt_decrypt]
      response_content[:custom_info] = decode(response_content[:custom_info]) if response_content[:custom_info]
      Result::Digest.new(response_content)
    end

  end
end
