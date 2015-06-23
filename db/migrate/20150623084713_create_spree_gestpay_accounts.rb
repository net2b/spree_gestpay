class CreateSpreeGestpayAccounts < ActiveRecord::Migration
  def change
    create_table :spree_gestpay_accounts do |t|
      t.references :user, index: true
      t.string :token
      t.string :month
      t.string :year
      t.string :last_digits
    end
  end
end
