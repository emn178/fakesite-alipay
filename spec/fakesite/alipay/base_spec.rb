RSpec.describe Fakesite::Alipay::Base do
  before { allow_any_instance_of(Time).to receive(:to_i).and_return(1441197000) }
  let(:base) { Fakesite::Alipay::Base.new :pid => Alipay.pid, :key => Alipay.key }
  let(:uri) { URI.parse(Alipay::Service.create_direct_pay_by_user_url(
      out_trade_no: '20150401000-0001',
      subject: 'Order Name',
      total_fee: '10.00',
      return_url: 'https://example.com/orders/20150401000-0001',
      notify_url: 'https://example.com/orders/20150401000-0001/notify'
    ))
  }
  subject { base }

  describe "#id" do
    its(:id) { should eq :alipay }
  end

  describe "#match" do
  	it { expect(base.match(uri)).to eq true }
  end

  describe "#parameters" do
  	it { expect(base.parameters(uri)).to eq({:trade_status => 'TRADE_SUCCESS', :trade_no => "1441197000", :notify_id => "1441197000" }) }
  end

  describe "#redirect_url" do
  	let(:redirect_url) { base.redirect_url(uri, base.parameters(uri)) }
  	let(:redirect_uri) { URI.parse(redirect_url) }
  	let(:redirect_params) {  Hash[CGI.parse(redirect_uri.query).map {|key,values| [key, values[0] || true]}] }
  	it { expect(redirect_url).to eq 'https://example.com/orders/20150401000-0001?trade_status=TRADE_SUCCESS&trade_no=1441197000&notify_id=1441197000&sign=d795b049eb400a5e2136bb772c1dbaa9&sign_type=MD5' }
  	it { expect(Alipay::Notify.verify?(redirect_params)).to eq true }
  end
end