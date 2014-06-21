$:.push File.expand_path("../lib", __FILE__)

require 'librarian/repo/version'

Gem::Specification.new do |gem|
  gem.name = 'librarian-repo'
  gem.version = Librarian::Repo::VERSION
  gem.platform = Gem::Platform::RUBY
  gem.authors = ['Marc Sutter']
  gem.email = ['marc.sutter@swissflow.ch']
  gem.homepage = 'https://github.com/msutter/librarian-repo'
  gem.summary = 'Bundler for your Repos'
  gem.description = 'Simplify deployment of your Repos by
  automatically pulling in git repositories with a single command.'

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}) { |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency "thor", "~> 0.15"
  gem.add_dependency "zipruby"


  gem.add_development_dependency "rake"
  gem.add_development_dependency "rspec", "~> 2.13"
end