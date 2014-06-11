require 'spec_helper'

def expect_option(default, expectation)
  it { expect(subject.get_option(default)).to eq expectation }
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
    it     { expect(subject.get).to be_success }
  end
end
