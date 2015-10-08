module Fakesite
  module Alipay
    class Base < Fakesite::Base
      include WebMock::API

      @@stubbed = false

      def initialize(options = {})
        unless @@stubbed
          @@stubbed = true
          stub_request(:get, 'https://' + Host + '/gateway.do')
            .with(:query => hash_including({:service => 'notify_verify'}))
            .to_return(:status => 200, :body => "true")
        end
        super(options)
      end

      def id
        :alipay
      end

      def match(external_uri)
        external_uri.host == Host
      end

      def parameters(external_uri)
        { :trade_status => 'TRADE_SUCCESS', :trade_no => Time.now.to_i.to_s, :notify_id => Time.now.to_i.to_s }
      end

      def return_parameters(params)
        string = params.sort.map { |item| item.join('=') }.join('&')
        params["sign"] = Digest::MD5.hexdigest("#{string}#{@options[:key]}")
        params["sign_type"] = "MD5"
        return params
      end
    end
  end
end
