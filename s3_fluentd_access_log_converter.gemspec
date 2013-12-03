# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 's3_fluentd_access_log_converter/version'

Gem::Specification.new do |spec|
  spec.name          = "s3_fluentd_access_log_converter"
  spec.version       = S3FluentdAccessLogConverter::VERSION
  spec.authors       = ["k1LoW"]
  spec.email         = ["k1lowxb@gmail.com"]
  spec.description   = %q{Get S3 'fluentd formatted access_log' and convert to combined access_log}
  spec.summary       = %q{Get S3 'fluentd formatted access_log' and convert to combined access_log}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"

  spec.add_dependency "aws-sdk"
  spec.add_dependency "json"
  spec.add_dependency "thor"
end
