class Spree::GestpayAccount < ActiveRecord::Base
  has_many :payments, as: :source
  belongs_to :user, class_name: "Spree::User"
  validates :token, presence: true
  before_create :set_last_digits

  alias_attribute :profile_token, :token

  def expiry_date
    "#{month}/#{year}"
  end

  def actions
    %w{capture void}
  end

  # Indicates whether its possible to capture the payment
  def can_capture?(payment)
    ['pending'].include?(payment.state)
  end

  # Indicates whether its possible to void the payment.
  def can_void?(payment)
    payment.state != 'void'
  end

  def crypted_number
    "XXXX XXXX XXXX #{last_digits}"
  end

  def presentation
    Spree.t(:credit_card_profile, expiry_date: expiry_date, last_digits: last_digits)
  end

  private

  def set_last_digits
    self.last_digits = token[-4,4]
  end
end
