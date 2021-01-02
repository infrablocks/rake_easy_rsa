# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rake_easy_rsa/version'

Gem::Specification.new do |spec|
  spec.name = 'rake_easy_rsa'
  spec.version = RakeEasyRSA::VERSION
  spec.authors = ['Toby Clemson']
  spec.email = ['tobyclemson@gmail.com']

  spec.summary = 'Rake tasks for managing PKI using EasyRSA.'
  spec.description = 'Rake tasks for common PKI management tasks using EasyRSA.'
  spec.homepage = "https://github.com/tobyclemson/rake_easy_rsa"
  spec.license = 'MIT'

  spec.files = `git ls-files -z`.split("\x0").select do |f|
    f.match(%r{^(bin|lib|CODE_OF_CONDUCT\.md|confidante\.gemspec|Gemfile|LICENSE\.txt|Rakefile|README\.md)})
  end
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 2.6'

  spec.add_dependency 'rake_dependencies', '~> 2', '< 3'
  spec.add_dependency 'rake_factory', '>= 0.23', '< 1'
  spec.add_dependency 'ruby_easy_rsa', '>= 0.7'
  spec.add_dependency 'semantic', '~> 1.6.1'

  spec.add_development_dependency 'bundler', '~> 2.1'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rake_circle_ci', '~> 0.9'
  spec.add_development_dependency 'rake_github', '~> 0.5'
  spec.add_development_dependency 'rake_ssh', '~> 0.4'
  spec.add_development_dependency 'rake_gpg', '~> 0.12'
  spec.add_development_dependency 'rspec', '~> 3.9'
  spec.add_development_dependency 'gem-release', '~> 2.0'
  spec.add_development_dependency 'activesupport', '>= 4'
  spec.add_development_dependency 'fakefs', '~> 0.18'
  spec.add_development_dependency 'simplecov', '~> 0.16'
end
