require 'spec_helper'

def expect_option(default, expectation)
  it { expect(subject[default]).to eq expectation }
end

describe Gestpay::Token do
  let (:options) {
    -> (o) {
      o.buyer_name  = "Kagami"
      o.buyer_email = "kagami@kyoani.jp"
      o.amount      = "20.40"
      o.transaction = "RS012398723422"
    }
  }

  subject { described_class.new(&options) }

  describe "default options" do
    expect_option(:language_id,   Gestpay::Language.default.code)
    expect_option(:uic_code,      Gestpay::Currency.default.code)
    expect_option(:request_token, "MASKEDPAN")
  end

  describe "#get" do
    let (:cassette) { "token" }
    before { VCR.insert_cassette cassette, :record => :new_episodes }
    after  { VCR.eject_cassette }
    it     { expect(subject.result).to be_success }
    it     { expect(subject.encrypted_string).to eq "qFuAQHY5L8TrjquQ6bDBYafOws9fdFCnANMqiD1CsF5TNqrAbRIbXEFX*BGDQaNz65d5xSV2AZNFUhEtHd*IudvbRvOAnVqgIunFqe11rCt6BhIdOcXRL0U2tcFMlsrCvSl4_iadMlJteJTbAQ4sQnql1QN6vE3QvwKcWZaN4zPARjbYbTHS5T0Qxo0hB2DRiUFlMarx7nxRJiOHm6FugdrYIiuennCxWMk0YxRhRykUWop*KC0vTX8akxaO8WTmbRCYQB1VknC_O4*cMHGGXQ" }
  end
end
