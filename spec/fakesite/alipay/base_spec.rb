RSpec.describe Fakesite::Alipay::Base do
  before { 
    allow(Time).to receive(:now).and_return(Time.at(1441197000)) 
    base.external_uri = uri
    base.params = params
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
      "buyer_email" => "", 
      "buyer_id" => "", 
      "exterface" => "create_direct_pay_by_user", 
      "notify_time" => "2015-09-02 20:30:00"
    }
  }
  subject { base }

  describe ".match" do
    it { expect(Fakesite::Alipay::Base.match(uri)).to eq true }
  end

  describe "#parameters" do
    its(:parameters) { should eq(params) }
  end

  describe "#return_parameters" do
    it { expect(URI.encode_www_form(base.return_parameters)).to eq "trade_status=TRADE_SUCCESS&trade_no=1441197000&notify_id=1441197000&buyer_email=&buyer_id=&exterface=create_direct_pay_by_user&notify_time=2015-09-02+20%3A30%3A00&sign=cf4e3556a7bdf61df2c197cd42f772f9&sign_type=MD5" }
    it { expect(Alipay::Notify.verify?(base.return_parameters)).to eq true }
  end

  describe "#redirect_url" do
    its(:redirect_url) { should eq 'https://example.com/orders/20150401000-0001?trade_status=TRADE_SUCCESS&trade_no=1441197000&notify_id=1441197000&buyer_email=&buyer_id=&exterface=create_direct_pay_by_user&notify_time=2015-09-02+20%3A30%3A00&sign=cf4e3556a7bdf61df2c197cd42f772f9&sign_type=MD5' }
  end
end
