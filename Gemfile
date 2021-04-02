# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

# Specify your gem's dependencies in checkability.gemspec.

gem 'activerecord', '~> 6.1', require: 'active_record'
gem 'activesupport', '~> 6.1', require: 'active_support'

# Development dependencies
group :development do
  gem 'sqlite3'
end

group :test do
  gem 'simplecov'
end
# To use a debugger
# gem 'byebug', group: [:development, :test]

gemspec
