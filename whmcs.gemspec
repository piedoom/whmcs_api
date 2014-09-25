$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "whmcs/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "whmcs"
  s.version     = Whmcs::VERSION
  s.authors     = ["TODO: Your name"]
  s.email       = ["TODO: Your email"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of Whmcs."
  s.description = "TODO: Description of Whmcs."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", ">= 3.2.0"
  s.add_dependency 'curb'

  s.add_development_dependency "sqlite3"
end
