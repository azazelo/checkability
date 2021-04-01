# frozen_string_literal: true

require_relative 'lib/checkability/version'

Gem::Specification.new do |spec|
  spec.name        = 'checkability'
  spec.version     = Checkability::VERSION
  spec.required_ruby_version = '>= 2.6.2'
  spec.authors     = ['Andrey Eremeev']
  spec.email       = ['andrey.eremeyev@gmail.com']
  spec.homepage    = 'https://github.com/azazelo/checkability'
  spec.summary     = 'Provide Checkers functionality.'
  spec.description = 'Provide Checkers functionality.'
  spec.license     = 'MIT'
  spec.metadata['allowed_push_host'] = 'https://rubygems.org'
  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://rubygems.org'
  spec.metadata['changelog_uri'] = 'https://rubygems.org'
  spec.files = Dir['{app,config,db,lib}/**/*',
                   'MIT-LICENSE', 'Rakefile', 'README.md']

  #  spec.add_dependency "rails", "~> 6.1.3", ">= 6.1.3.1"
  spec.executables << 'checkability'
end
