module Gestpay
  # This logger is meant to intercept a request/response

  class ParseLogger
    SOAP_REQ_URL_RGX  = /^SOAP request: (.*?)$/
    SOAP_RES_CODE_RGX = /^SOAP response \(status (\d+)\)$/

    def initialize
      # state:

      #     :waiting_req_url
      #  -> :waiting_req_headers
      #  -> :waiting_req_body

      #  -> :waiting_res_code
      #  -> :waiting_res_headers
      #  -> :waiting_res_body

      #  -> :done

      @state = :waiting_req_url
    end

    def debug(message)
      case @state
      when :waiting_req_body
        @state    = :waiting_res_code
        @req_body = message
      when :waiting_res_body
        @state    = :done
        @res_body = message
      end
    end

    def info(message)
      case @state
      when :waiting_req_url
        if message =~ SOAP_REQ_URL_RGX
          @state   = :waiting_req_headers
          @req_url = $1
        end
      when :waiting_req_headers
        @state       = :waiting_req_body
        @req_headers = message
      when :waiting_res_code
        if message =~ SOAP_RES_CODE_RGX
          @state    = :waiting_res_body
          @res_code = $1
        end
      end
    end

    def to_h
      check_state

      Marshal.load(Marshal.dump({
        :req_url  => @req_url,
        :req_body => @req_body,
        :res_code => @res_code,
        :res_body => @res_body,
      }))
    end

    private
    def check_state
      raise Exceptions::InconsistentLoggerState unless @state == :done
    end
  end
end
