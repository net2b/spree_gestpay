Spree::User.class_eval do
  has_many :gestpay_accounts, class_name: "Spree::GestpayAccount"
end
