# coding: utf-8
# frozen_string_literal: true
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'jenkins_plugin_bundler/version'

Gem::Specification.new do |spec|
  spec.name          = 'jenkins_plugin_bundler'
  spec.version       = JenkinsPluginBundler::VERSION
  spec.authors       = ['Christian Höltje']
  spec.email         = ['docwhat@gerf.org']

  spec.summary       = 'Jenkins plugin bundler, dependency resolver, ' \
  'and downloader'
  spec.description = 'Provides ruby methods for looking up Jenkins ' \
  'plugins, resolving dependencies, and downloading the plugins.'
  spec.homepage      = 'https://github.com/docwhat/jenkins_plugin_bundler'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.required_ruby_version = '~> 2.3'

  spec.add_development_dependency 'bundler', '~> 1.13'
  spec.add_development_dependency 'rake', '~> 13.1'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop', '~> 0.44.1'
end
