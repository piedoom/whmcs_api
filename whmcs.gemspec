$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "whmcs/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'whmcs_api'
  s.version     = Whmcs::VERSION
  s.authors     = ['Bogdan Guban']
  s.email       = ['biguban@gmail.com']
  s.homepage    = 'https://github.com/bguban/whmcs_api'
  s.summary     = 'WHMCS API library written on ruby'
  s.description = 'WHMCS API library written on ruby'
  s.license     = 'MIT'

  s.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.rdoc']
  s.test_files = Dir['test/**/*']
  s.required_ruby_version = '>= 1.9.3'


  s.add_dependency 'rails', '>= 3.2.0'
  s.add_dependency 'curb'
  s.add_dependency 'php-serialize'

  s.add_development_dependency 'sqlite3'
end
