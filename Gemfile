source "https://rubygems.org"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 8.0.2"
# Use sqlite3 as the database for Active Record
gem "sqlite3", ">= 2.1"
# Use the Puma web server [https://github.com/puma/puma]
gem "puma", ">= 5.0"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[ windows jruby ]

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin Ajax possible
# gem "rack-cors"

# Encrypted passwords via Rails auth setup.
gem "bcrypt"

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"

  # See https://github.com/rspec/rspec-rails?tab=readme-ov-file#installation
  # Adding to test & development avoids needing RAILS_ENV=test every time.
  gem 'rspec'
  gem 'rspec-rails'
  gem 'factory_bot_rails'
end

group :development do
  gem 'rubocop', require: false
  gem 'rubocop-rspec', require: false
end
