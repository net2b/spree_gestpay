module Gestpay
  class Host
    def self.c2s; new(:c2s); end
    def self.s2s; new(:s2s); end

    HOSTS = {
      s2s: {
        production: 'https://ecomm.sella.it/',
        default:    'https://testecomm.sella.it/'
      },
      c2s: {
        production: 'https://ecomm.sella.it/',
        default:    'https://testecomm.sella.it/'
      }
    }

    def initialize(kind)
      hosts = HOSTS.fetch(kind)
      @host = hosts.fetch(Gestpay.config.environment, hosts[:default])
    end

    def /(path)
      URI.join(@host, path).to_s
    end
  end
end
