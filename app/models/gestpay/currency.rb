module Gestpay
  class Currency < Mapping
    private
    def self.mapping
      {
        'EUR' => '242',
        'ITL' => '18',
        'BRL' => '234',
        'USD' => '1',
        'JPY' => '71',
        'HKD' => '103'
      }
    end
  end
end
