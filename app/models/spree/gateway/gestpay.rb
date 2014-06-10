module Spree
  class Gateway::Gestpay < Gateway
    def supports?(source)
      true
    end

    def auto_capture?
      true
    end

    def method_type
      'gestpay'
    end
  end
end
