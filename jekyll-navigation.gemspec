# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'jekyll-navigation/version'

Gem::Specification.new do |gem|
  gem.name          = "jekyll-navigation"
  gem.version       = JekyllNavigation::VERSION
  gem.authors       = ["Jens Bissinger"]
  gem.email         = ["mail@jens-bissinger.de"]
  gem.description   = %q{TODO: Write a gem description}
  gem.summary       = %q{TODO: Write a gem summary}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency "liquid"
  gem.add_development_dependency "rspec"
  gem.add_development_dependency "jekyll"
end
