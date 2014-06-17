module Gestpay::Exceptions
  class InconsistentLoggerState < Exception
    def message
      "Stato logger incosistente"
    end
  end
end
