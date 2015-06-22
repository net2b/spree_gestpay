require 'rails_helper'

feature "GestPay", js: true do
  let(:product_name) { 'Rare Candy' }
  let(:country)      { 'United States of America' }
  let(:state)        { 'Alabama' }
  let!(:product)     { FactoryGirl.create(:product, name: product_name) }

  def fill_in_billing
    within("#billing") do
      fill_in "First Name",     with: "Test"
      fill_in "Last Name",      with: "User"
      fill_in "Street Address", with: "1 User Lane"
      fill_in "City",           with: "Adamsville"
      select  country,          from: "order_bill_address_attributes_country_id"
      select  state,            from: "order_bill_address_attributes_state_id"
      fill_in "Zip",            with: "35005"
      fill_in "Phone",          with: "555-AME-RICA"
    end
  end

  before do
    @gateway = Spree::Gateway::Gestpay.create!({
      name: "Credit card", active: true, environment: Rails.env })
    shipping_method = FactoryGirl.create(:shipping_method)
    state = FactoryGirl.create(:state)
    state.country.update_column(:name, country)
    shipping_method.zones.first.zone_members.create(zoneable: state.country)
  end

  it "pays for an order successfully" do
    use_js_stubs("standard-ok")
    visit spree.root_path
    click_link product_name
    click_button 'Add To Cart'
    click_button 'Checkout'
    within('#guest_checkout') do
      fill_in 'Email', with: 'test@example.com'
      click_button 'Continue'
    end
    fill_in_billing
    click_button 'Save and Continue'
    click_button 'Save and Continue' # use default delivery method
    keep_open
  end
end
