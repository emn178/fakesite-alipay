# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fakesite/alipay/version'

Gem::Specification.new do |spec|
  spec.name          = "fakesite-alipay"
  spec.version       = Fakesite::Alipay::VERSION
  spec.authors       = ["Chen Yi-Cyuan"]
  spec.email         = ["emn178@gmail.com"]

  spec.summary       = %q{A fakesite plugin that provides a stub method for alipay.}
  spec.description   = %q{A fakesite plugin that provides a stub method for alipay.}
  spec.homepage      = "https://github.com/emn178/fakesite-alipay"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.require_paths = ["lib"]

  spec.add_dependency "fakesite"
  spec.add_dependency "webmock"

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "rspec-its"
  spec.add_development_dependency "alipay"
end
