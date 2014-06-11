module Gestpay
  class Language < Mapping
    private
    def self.mapping
      {
        'en-US' => '2',
        'it-IT' => '1',
        'es-ES' => '3',
        'fr-FR' => '4',
        'de-DE' => '5',
      }
    end
  end
end

