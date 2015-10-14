RSpec.describe Fakesite::Alipay::Base do
  before { 
    allow(Time).to receive(:now).and_return(Time.at(1441197000)) 
    base.external_uri = uri
    base.params = params
    base.user = user
  }
  let(:base) { Fakesite::Alipay::Base.new :pid => Alipay.pid, :key => Alipay.key }
  let(:uri) { URI.parse(Alipay::Service.create_direct_pay_by_user_url(
      out_trade_no: '20150401000-0001',
      subject: 'Order Name',
      total_fee: '10.00',
      return_url: 'https://example.com/orders/20150401000-0001',
      notify_url: 'https://example.com/orders/20150401000-0001/notify'
    ))
  }
  let(:params) {
    {
      "trade_status" => "TRADE_SUCCESS", 
      "trade_no" => "1441197000", 
      "notify_id" => "1441197000", 
      "buyer_email" => "emn178@gmail.com", 
      "buyer_id" => 1, 
      "exterface" => "create_direct_pay_by_user", 
      "notify_time" => "2015-09-02 20:30:00"
    }
  }
  let(:user) {
    OpenStruct.new(
      :id => 1,
      :email => "emn178@gmail.com"
    )
  }
  subject { base }

  describe ".match" do
    it { expect(Fakesite::Alipay::Base.match(uri)).to eq true }
  end

  describe "#parameters" do
    its(:parameters) { should eq(params) }
  end

  describe "#return_parameters" do
    it { expect(URI.encode_www_form(base.return_parameters)).to eq "trade_status=TRADE_SUCCESS&trade_no=1441197000&notify_id=1441197000&buyer_email=emn178%40gmail.com&buyer_id=1&exterface=create_direct_pay_by_user&notify_time=2015-09-02+20%3A30%3A00&sign=1c9da0059439ab65c45256169a0e58a9&sign_type=MD5" }
    it { expect(Alipay::Notify.verify?(base.return_parameters)).to eq true }
  end

  describe "#redirect_url" do
    its(:redirect_url) { should eq 'https://example.com/orders/20150401000-0001?trade_status=TRADE_SUCCESS&trade_no=1441197000&notify_id=1441197000&buyer_email=emn178%40gmail.com&buyer_id=1&exterface=create_direct_pay_by_user&notify_time=2015-09-02+20%3A30%3A00&sign=1c9da0059439ab65c45256169a0e58a9&sign_type=MD5' }
  end

  describe "#buyer_id" do
    context "with user" do
      its(:buyer_id) { should eq user.id }
    end

    context "without user" do
      before { base.user = nil }
      its(:buyer_id) { should eq nil }
    end
  end

  describe "#buyer_email" do
    context "with user" do
      its(:buyer_email) { should eq user.email }
    end

    context "without user" do
      before { base.user = nil }
      its(:buyer_email) { should eq nil }
    end
  end
end
