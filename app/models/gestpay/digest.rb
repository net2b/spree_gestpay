module Gestpay
  class Digest
    include Coders

    URL = {
      :test       => 'https://testecomm.sella.it/gestpay/gestpayws/WSCryptDecrypt.asmx?WSDL',
      :production => 'https://ecomms2s.sella.it/gestpay/gestpayws/WSCryptDecrypt.asmx?WSDL'
    }

    def initialize(args={})
      args = {wsdl: URL[Gestpay.config.environment]}.merge(args)
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
