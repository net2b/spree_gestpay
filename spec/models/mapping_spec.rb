shared_examples "a mapping" do
  subject { described_class.new(label) }

  describe ".default" do
    it { expect(described_class.default).to eq described_class.new(label) }
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
  let(:label) { "ITA" }
  let(:code)  { "1" }
  it_behaves_like "a mapping"
end
