# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rep_data_client/version'

Gem::Specification.new do |spec|
  spec.name          = "rep_data_client"
  spec.version       = RepDataClient::VERSION
  spec.authors       = ["DaliaResearch"]
  spec.email         = ["it@daliaresearch.com"]

  spec.summary       = %q{Ruby wrapper for RepData's API}
  spec.description   = %q{Ruby wrapper for RepData's API}
  spec.homepage      = "https://github.com/DaliaResearch/RepDataClient"
  spec.license       = "Dalia Research GmbH"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.require_paths = ["lib"]

  spec.add_dependency "httparty"
  spec.add_dependency "duplicate"
  spec.add_dependency "dotenv"

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency "fakeweb"
end
