# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rake_easy_rsa/version'

files = %w[
  bin
  lib
  CODE_OF_CONDUCT.md
  rake_easy_rsa.gemspec
  Gemfile
  LICENSE.txt
  Rakefile
  README.md
]

Gem::Specification.new do |spec|
  spec.name = 'rake_easy_rsa'
  spec.version = RakeEasyRSA::VERSION
  spec.authors = ['InfraBlocks Maintainers']
  spec.email = ['maintainers@infrablocks.io']

  spec.summary = 'Rake tasks for managing PKI using EasyRSA.'
  spec.description = 'Rake tasks for common PKI management tasks using EasyRSA.'
  spec.homepage = 'https://github.com/infrablocks/rake_easy_rsa'
  spec.license = 'MIT'

  spec.files = `git ls-files -z`.split("\x0").select do |f|
    f.match(/^(#{files.map { |g| Regexp.escape(g) }.join('|')})/)
  end
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 3.1'

  spec.add_dependency 'rake_dependencies', '~> 3.1'
  spec.add_dependency 'rake_factory', '~> 0.23'
  spec.add_dependency 'ruby_easy_rsa', '~> 0.13'
  spec.add_dependency 'semantic', '~> 1.6'

  spec.add_development_dependency 'activesupport'
  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'fakefs'
  spec.add_development_dependency 'gem-release'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rake_circle_ci'
  spec.add_development_dependency 'rake_git'
  spec.add_development_dependency 'rake_git_crypt'
  spec.add_development_dependency 'rake_github'
  spec.add_development_dependency 'rake_gpg'
  spec.add_development_dependency 'rake_ssh'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'rubocop-rake'
  spec.add_development_dependency 'rubocop-rspec'
  spec.add_development_dependency 'simplecov'

  spec.metadata['rubygems_mfa_required'] = 'false'
end
