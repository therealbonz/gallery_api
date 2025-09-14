source "https://rubygems.org"

ruby "~> 3.2"

# Rails core
gem "rails", "~> 8.0.2", ">= 8.0.2.1"
gem "pg", "~> 1.1"
gem "puma", ">= 5.0"

# Authentication
gem "devise"
gem "devise_token_auth"

# File uploads & image processing
gem "image_processing", "~> 1.2"
gem "active_storage_validations"

# CORS (for React frontend / APIs)
gem "rack-cors"

# Rails 8 new async stack
gem "solid_cache"
gem "solid_queue"
gem "solid_cable"

# Performance / deployment
gem "bootsnap", require: false
gem "kamal", require: false
gem "thruster", require: false

# Windows support (safe to leave in)
gem "tzinfo-data", platforms: %i[ windows jruby ]

group :development, :test do
  # Debugging
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"
  gem "pry"

  # Security analysis
  gem "brakeman", require: false

  # Code style / linting
  gem "rubocop-rails-omakase", require: false
end


gem "kaminari", "~> 1.2"
