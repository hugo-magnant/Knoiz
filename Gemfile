source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.2.2"

gem "bootsnap", require: false
gem 'dotenv-rails', require: 'dotenv/rails-now'
gem "importmap-rails"
gem "jbuilder"
gem 'pg'
gem "puma", "~> 5.0"
gem "rails", ">= 7.0.8.1"
gem "redis"
gem 'rspotify'
gem "ruby-openai"
gem "sprockets-rails"
gem 'sidekiq'
gem "stimulus-rails"
gem 'stripe'
gem "tailwindcss-rails"
gem "turbo-rails"
gem "tzinfo-data", platforms: %i[ mingw mswin x64_mingw jruby ]
gem "whenever", require: false

group :development, :test do
  gem "debug", platforms: %i[ mri mingw x64_mingw ]
  gem 'rspec-rails'
end

group :development do
  gem "web-console"
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
  gem "webdrivers"
end