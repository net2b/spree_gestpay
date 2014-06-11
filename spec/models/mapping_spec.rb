require 'spec_helper'

shared_examples "a mapping" do
  subject { described_class.new(label) }
  let (:sample) { described_class.new(label) }

  describe ".default" do
    it { expect(described_class.default).to eq sample }
  end

  describe ".from_code" do
    it { expect(described_class.from_code(code)).to eq sample }
  end

  describe "#code" do
    it { expect(subject.code).to eq code }
  end

  it "has a string representation" do
    expect(subject.to_s).to eq label
  end
end

describe Gestpay::Currency do
  let(:label) { "EUR" }
  let(:code)  { "242" }
  it_behaves_like "a mapping"
end

describe Gestpay::Language do
  let(:label) { "en" }
  let(:code)  { "2" }
  it_behaves_like "a mapping"
end
