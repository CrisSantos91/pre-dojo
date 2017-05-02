# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "Pre Dojo"
  spec.version       = '1.0'
  spec.authors       = ["Daniel de Aguiar Kamakura"]
  spec.email         = ["daniel.kamakura@gmail.com"]
  spec.summary       = %q{Short summary of your project}
  spec.description   = %q{Longer description of your project.}
  spec.homepage      = "http://domainforproject.com/"
  spec.license       = "MIT"

  spec.files         = ['lib/pre_dojo.rb']
  spec.executables   = ['bin/pre_dojo']
  spec.test_files    = ['tests/test_pre_dojo.rb']
  spec.require_paths = ["lib"]
end