# frozen_string_literal: true

source 'https://rubygems.org'

gemspec

gem 'cssbundling-rails'
gem 'dotenv'
gem 'haml-rails'
gem 'jsbundling-rails'
gem 'listen'
gem 'propshaft'
gem 'puma', require: false
gem 'rake', require: false
gem 'rspec-rails', require: false
gem 'sqlite3'
# TODO: Move to gemspec.
gem 'umts-brand', '0.0.0.pre.dev', github: 'umts/brand', branch: 'main'

group :development do
  gem 'haml-lint', require: false
  gem 'overcommit', require: false
  gem 'rubocop-capybara', require: false
  gem 'rubocop-performance', require: false
  gem 'rubocop-rails', require: false
  gem 'rubocop-rake', require: false
  gem 'rubocop-rspec', require: false
  gem 'rubocop-rspec_rails', require: false
  gem 'web-console'
end

group :test do
  gem 'capybara'
  gem 'factory_bot_rails'
  gem 'simplecov', require: false
end
