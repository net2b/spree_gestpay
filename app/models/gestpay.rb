module Gestpay
  def self.setup
    yield self.config
  end

  def self.config
    @config ||= Gestpay::Config.new
  end
end

