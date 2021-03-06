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
  s.summary     = %q{Rails 3 engine that provides a Git backed CMS that allows for an admin to define editable regions in a page view.}
  s.description = %q{Rails 3 engine that provides a Git backed CMS that allows for an admin to define editable regions in a page view.}

  s.rubyforge_project = "regulate"

  s.add_dependency "rails", "~> 3.0.0"
  s.add_dependency "grit", "~> 2.3.0"
  s.add_dependency "abstract_auth", "~> 0.1.3"
  s.add_dependency "json", "~> 1.4.6"
  s.add_development_dependency "bluecloth", "~> 2.0.9"
  s.add_development_dependency "bundler", "~> 1.0.0"
  s.add_development_dependency "capybara", "~> 0.4.0"
  s.add_development_dependency "sqlite3-ruby", "~> 1.3.2"
  s.add_development_dependency "yard", "~> 0.6.4"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
