require 'rails_helper'

describe Spree::GestpayController, type: :controller do
  describe "#token" do
    let (:cassette) { "token" }
    use_http_recordings

    it "successfully gets a new token" do
      json      = { transaction: "ABC", amount: "123" }.to_json
      json_type = { "CONTENT_TYPE" => "application/json" }
      post spree.gestpay_get_token_path, json, json_type
      expect(response.body).to eq({
        token: "qFuAQHY5L8TrjquQ6bDBYafOws9fdFCnANMqiD1CsF5TNqrAbRIbXEFX*BGDQaNz65d5xSV2AZNFUhEtHd*IudvbRvOAnVqgIunFqe11rCt6BhIdOcXRL0U2tcFMlsrCvSl4_iadMlJteJTbAQ4sQnql1QN6vE3QvwKcWZaN4zPARjbYbTHS5T0Qxo0hB2DRiUFlMarx7nxRJiOHm6FugdrYIiuennCxWMk0YxRhRykUWop*KC0vTX8akxaO8WTmbRCYQB1VknC_O4*cMHGGXQ"
      }.to_json)
    end
  end
end
