source "https://rubygems.org"

# Rails
gem "rails", "~> 8.1"

# Drivers
gem "pg", "~> 1.6"
gem "redis", ">= 4.0.1"

# Pin connection_pool to 2.x - connection_pool 3.x has a breaking change
# (keyword-only arguments) that is incompatible with Rails 8.1.1's
# ActiveSupport::Cache::RedisCacheStore, causing assets:precompile to fail with
# `ArgumentError: wrong number of arguments (given 1, expected 0)`.
# See https://github.com/rails/rails/issues/56461
gem "connection_pool", "~> 2.5"

# Deployment
gem "puma", ">= 5.0"
gem "bootsnap", require: false

# Assets
gem "importmap-rails"
gem "propshaft"
gem "tailwindcss-rails"
gem "lucide-rails", github: "maybe-finance/lucide-rails"

# Background Jobs
gem "sidekiq"
gem "sidekiq-cron"

# Hotwire
gem "stimulus-rails"
gem "turbo-rails"
gem "hotwire_combobox", "~> 0.4.1"

# Other
gem "faraday"
gem "jbuilder"
gem "plaid", "~> 44.1"
gem "tzinfo-data", platforms: %i[ mswin mswin64 mingw x64_mingw jruby ]
gem "redcarpet"
gem "avo", ">= 3.2"
gem "revise_auth"
gem "pagy"
gem "ransack"
gem "bannerbear"
# gem "vernier"
gem "sentry-ruby"
gem "sentry-rails"
gem "logtail-rails"
gem "skylight"
gem "ffi", ">= 1.17"
gem "ruby-openai"
gem "posthog-ruby"

group :development, :test do
  gem "debug", platforms: %i[ mri mswin mswin64 mingw x64_mingw ]
  gem "brakeman", require: false
  gem "rubocop-rails-omakase", require: false
  gem "dotenv-rails"
  gem "erb_lint", require: false
end

group :development do
  gem "web-console"
  gem "hotwire-livereload"
  gem "ruby-lsp-rails"
  gem "annotate"
  gem "rails_performance"
  gem "rack-mini-profiler"
end

group :test do
  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  gem "capybara"
  gem "selenium-webdriver"
  gem "mocha"
  gem "vcr"
  gem "webmock"
end
