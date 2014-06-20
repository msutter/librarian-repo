$:.push File.expand_path("../lib", __FILE__)

require 'librarian/repo/version'

Gem::Specification.new do |s|
  s.name = 'librarian-repo'
  s.version = Librarian::Repo::VERSION
  s.platform = Gem::Platform::RUBY
  s.authors = ['Marc Sutter']
  s.email = ['marc.sutter@swissflow.ch']
  s.homepage = 'https://github.com/msutter/librarian-repo'
  s.summary = 'Bundler for your Repos'
  s.description = 'Simplify deployment of your Repos by
  automatically pulling in git repositories with a single command.'

  s.files         = `git ls-files`.split($/)
  s.executables   = s.files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.test_files    = s.files.grep(%r{^(test|spec|features)/})
  s.require_paths = ["lib"]

  s.add_dependency "thor", "~> 0.15"

  s.add_development_dependency "rspec", "~> 2.13"
end