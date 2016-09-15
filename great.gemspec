# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'great/version'

Gem::Specification.new do |spec|
  spec.name          = "great"
  spec.version       = Great::VERSION
  spec.authors       = ["'Jim Gay'"]
  spec.email         = ["'jim@saturnflyer.com'"]

  spec.summary       = %q{Sound like Trump}
  spec.description   = %q{Take some text and make it sound like Trump.}
  spec.homepage      = "https://github.com/saturnflyer/great"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_dependency "sentimental", "~> 1.4.0"
end
