module Fakesite
  module Alipay
    class Base < Fakesite::Base
      extend WebMock::API

      def parameters
        { 
          "trade_status" => 'TRADE_SUCCESS', 
          "trade_no" => Time.now.to_i.to_s, 
          "notify_id" => Time.now.to_i.to_s,
          "buyer_email" => buyer_email,
          "buyer_id" => buyer_id,
          "exterface" => "create_direct_pay_by_user",
          "notify_time" => (Time.now.utc + 28800).strftime("%Y-%m-%d %H:%M:%S")
        }
      end

      def return_parameters
        string = params.sort.map { |item| item.join('=') }.join('&')
        params["sign"] = Digest::MD5.hexdigest("#{string}#{@options[:key]}")
        params["sign_type"] = "MD5"
        return params
      end

      def buyer_email
        get_value(user, :email)
      end

      def buyer_id
        get_value(user, :id)
      end

      def self.match(external_uri)
        external_uri.host == Host
      end

      def self.after_register
        stub_request(:get, 'https://' + Host + '/gateway.do')
            .with(:query => hash_including({:service => 'notify_verify'}))
            .to_return(:status => 200, :body => "true")
      end

      protected

      def get_value(obj, attr_name)
        !obj.nil? && obj.respond_to?(attr_name) ? obj.send(attr_name) : nil
      end
    end
  end
end
