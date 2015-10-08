# fakesite-alipay

[![Build Status](https://api.travis-ci.org/emn178/fakesite-alipay.png)](https://travis-ci.org/emn178/fakesite-alipay)
[![Coverage Status](https://coveralls.io/repos/emn178/fakesite-alipay/badge.svg?branch=master)](https://coveralls.io/r/emn178/fakesite-alipay?branch=master)

A [fakesite](https://github.com/emn178/fakesite) plugin that provides a stub method for alipay. It's useful to bypass payment flow in develpment environment.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'fakesite-alipay', group: :development
```

And then execute:

    $ bundle

### Route
Make sure that you have added fakesite route in your `config/route.rb`
```Ruby
mount Fakesite::Engine => "/fakesite" if Rails.env.development?
```

## Usage
Add registration to `config/initializers/fakesite.rb`
```Ruby
if Rails.env.development?
	Fakesite.register Fakesite::Alipay::Base.new {:pid => 'PID', :key => 'KEY'}
end
```

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## Contact
The project's website is located at https://github.com/emn178/fakesite-alipay  
Author: emn178@gmail.com
