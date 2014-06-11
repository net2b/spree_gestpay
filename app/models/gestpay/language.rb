module Gestpay
  class Language < Mapping
    private
    def self.mapping
      {
        'en' => '2',
        'it' => '1',
        'es' => '3',
        'fr' => '4',
        'de' => '5',
      }
    end
  end
end

