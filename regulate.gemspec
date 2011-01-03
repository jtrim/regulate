# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "regulate/version"

Gem::Specification.new do |s|
  s.name        = "regulate"
  s.version     = Regulate::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Collin Schaafsma", "Ryan Cook"]
  s.email       = ["collin@quickleft.com", "ryan@quickleft.com"]
  s.homepage    = ""
  s.summary     = %q{The CMS we always wanted.}
  s.description = %q{The CMS we always wanted.}

  s.rubyforge_project = "regulate"

  s.add_dependency "rails", "~> 3.0.0"
  s.add_dependency "grit", "~> 2.3.0"
  s.add_development_dependency "bundler", "~> 1.0.0"
  s.add_development_dependency "capybara", "~> 0.4.0"
  s.add_development_dependency "sqlite3-ruby", "~> 1.3.2"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
