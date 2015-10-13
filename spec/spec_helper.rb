require 'simplecov'
require 'coveralls'

SimpleCov.add_filter "/spec/"

if ENV["COVERAGE"]
  SimpleCov.start
elsif ENV["COVERALLS"]
  SimpleCov.formatter = Coveralls::SimpleCov::Formatter
  Coveralls.wear!
end

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'alipay'
require 'fakesite/alipay'
require 'rspec/its'

Alipay.pid = 'PID'
Alipay.key = 'KEY'

Fakesite.register :alipay, Fakesite::Alipay::Base, {:pid => Alipay.pid, :key => Alipay.key}
