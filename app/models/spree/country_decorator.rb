Spree::Country.class_eval do
  def correct_iso3
    # if the iso3 is correct, gestpay_iso3 is nil
    presence.try(:gestpay_iso3) || presence.try(:iso3)
  end
end
