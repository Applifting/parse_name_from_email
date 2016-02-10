# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'parse_name_from_email/version'

Gem::Specification.new do |spec|
  spec.name          = 'parse_name_from_email'
  spec.version       = ParseNameFromEmail::VERSION
  spec.authors       = ['Prokop Simek, Applifting']
  spec.email         = ['prokop.simek@applifting.cz']

  spec.summary       = 'Parse name from email address.'
  spec.description   = 'This gem makes it easy to parse name from email addresses.'
  spec.homepage      = 'https://github.com/Applifting/parse_name_from_email'
  spec.license       = 'MIT'
  
  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'activesupport'

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake'
end
