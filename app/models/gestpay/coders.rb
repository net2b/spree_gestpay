module Gestpay
  module Coders
    def encode(custom_info)
      custom_info.collect{|k,v| "#{k}=#{v.to_s.unpack('H*')[0]}"}.sort.join('*P1*')
    end

    def decode(string)
      string.split('*P1*').inject({}) { |mem, var| k,v=var.split('='); mem[k]=[v].pack('H*') ; mem }
    end
  end
end
