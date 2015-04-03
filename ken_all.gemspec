lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

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

  s.files         = `git ls-files`.split($/)
  s.executables   = s.files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.test_files    = s.files.grep(%r{^(test|spec|features)/})
  s.require_paths = ['lib']

  s.add_dependency "activerecord-import","~> 0.4"
  s.add_dependency "rails", ">= 3.0.9"
  s.add_dependency "rubyzip", '~> 1.0'
  s.add_dependency "curses", '~> 1.0'

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "rr", "~> 1.1"
  s.add_development_dependency "rails", "~> 3.2"
end
