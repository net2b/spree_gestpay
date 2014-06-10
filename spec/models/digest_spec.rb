require 'spec_helper'

describe Gestpay::Digest do

  let(:digest) { Gestpay::Digest.new(:log => false) }
  subject { result }
  before  { VCR.insert_cassette cassette, :record => :new_episodes }
  after   { VCR.eject_cassette }

  describe '#encrypt' do
    let(:result) { digest.encrypt(hash) }

    context "with an ok data hash" do
      let(:cassette) { 'encrypt_ok' }
      let(:hash) do
        {
          :uic_code => '242',
          :amount => '0.01',
          :shop_transaction_id => '123',
          :language_id => '1',
          :buyer_name => "Test Customer",
          :buyer_email => "test@example.com"
        }
      end

      it { is_expected.to respond_to(:success?) }
      it { is_expected.to be_success }
      it { expect(subject.encrypted_string).to include('i3eUhxjb5HNxldtVSXb4qxaYva_uWKNn6BSQgRXkBUWKjoQvU6IbNgocbJYSr2LZ3FdnsvnpXH8KQ1') }
    end

    context "with a wrong data hash" do
      let(:cassette) { 'encrypt_ko' }
      let(:hash) { Hash.new }

      it { is_expected.not_to be_success }
    end
  end

  describe '#decrypt' do
    context "with an ok transaction" do
      let(:cassette) { 'decrypt_ok' }
      let(:result ) { digest.decrypt('rxd4jKk3CN8PbPX7gHh9u60ocD8_R85bI0NR_C*SOk1r1y2P8E9fDBgXKmmMnyyhyosyF8X6rvyTs_GCulPAy8TZKJc99tSb57cAWuo36MZ9_OWp2pwgKYLx7jS9XaLBgAqBufiFIoPq*Pwj5SdHY06vUf3ebnKryDvRnC0oldLw1YxpkIxlebYd7YxvNfSGLfSvce2NN8wWcwPfdR2jPKb*_oJpCEVZNO5TVMaH6h1UONEksNLIuDeZPqWfrHRcgbi0MLuoifb7ZBGrTw7HlEqfF6ojKt2oihKtNdn3Y3W5MkBHCsBrWq63TLYlDU8PRaV20jAdqQIJBHopVyumMGtyLoHlMFaH*nXUvgzwmYnTtwQZ*Q1nGCP0cl4YilBcivSTJCOkcrRwUhqYOl*4F1kmT15Nkp_sBB4oJRODYs8') }

      it { is_expected.to be_success }
      it { expect(subject.buyer_name).to  eq "Test Customer" }
      it { expect(subject.buyer_email).to eq "test@example.com" }
      it { expect(subject.shop_transaction_id).to eq '123' }
    end

    context "with a failed transaction" do
      let(:cassette) { 'decrypt_ko' }
      let(:result ) { digest.decrypt('KFzOej9MGr*lXEe*LOB2wzLmHja3ghKAo3iMpR1pG35moFdejWKzAj1Zd*R_e0x8qyOSTQmZVGRXEzJMVzd9xRXS*7tkbQLPOuBZ7qAtoFsX2Fxks5HxY*3YsUeiOInUXNF7*ih1bzkwmYGchDqYnEi31rN8ZYwLHnjwMIEmWJNn7oJHE6RpfUHG*7qohDxZRto*VVTPFdM93CwECq7SdYLebAQ_9EefdcE90QCRcFdGxZp_yAr_t*YRgLcZ5B5j843krtjCvf_m8nS99CroJQ768XsvlXy29McM2G*369mTufGyGMRab5PIvJlpSd3ds6mGi1IoMJAyXVkCu_ygRDDXN5Fk4Hz58LrDIci4ZszyVRcqy56SeYV7eG*kG8LZV40WV2ey8Qeh8XDUZnCV3A') }

      it { is_expected.not_to be_success }
      it { expect(subject.error).to eq "Error 74: Autorizzazione negata" }
    end
  end

end
