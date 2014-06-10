require 'spec_helper'

feature "GestPay", js: true do
  let(:product_name) { 'Rare Candy' }
  let!(:product)     { FactoryGirl.create(:product, name: product_name) }

  it "pays for an order successfully" do
    visit spree.root_path
    click_link product_name
  end
end
