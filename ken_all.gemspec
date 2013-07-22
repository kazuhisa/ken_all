$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "ken_all/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "ken_all"
  s.version     = KenAll::VERSION
  s.authors     = ["Yamamoto Kazuhisa"]
  s.email       = ["ak.hisashi@gmail.com"]
  s.homepage    = "https://github.com/kazuhisa/ken_all"
  s.summary     = "Japanese postal code tools."
  s.description = "Japanese postal code tools."
  s.license       = 'MIT'

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc","Gemfile","Gemfile.lock"]

  s.add_dependency "activerecord-import","~> 0.4"
  s.add_dependency "zipruby",">= 0"
  s.add_dependency "rails", ">= 3.0.9"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "rr", "~> 1.1"
  s.add_development_dependency "rails", "~> 3.2"
end
