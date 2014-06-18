module Gestpay
  class SoapClient
    def initialize(args)
      @client = Savon.client(args.merge(logger: logger, log: true))
    end

    def call(method, message)
      reset
      @client.globals[:logger] = logger
      @client.globals[:log]    = true
      message = message.merge(shop_login: Gestpay.config.account)
      @client.call(method, {message: message})
    end

    def logger
      @logger ||= ParseLogger.new
    end

    private
    def reset
      @logger = nil
    end
  end
end
