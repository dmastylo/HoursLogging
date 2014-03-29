source 'https://rubygems.org'

# Ruby
ruby '2.1.0'

# Rails
gem 'rails', '>= 4.0.4'

# Bootstrap
gem 'bootstrap-sass'

# Devise
gem 'devise'

# Thin web server
gem 'thin'

# jquery rails
gem 'jquery-rails'

# Pagination
gem 'will_paginate'
gem 'bootstrap-will_paginate'

# Gem for money printing and storing
gem 'money-rails'

group :development do
  gem 'annotate'
end

# Development
group :development, :test do
  gem 'sqlite3'
  gem 'rspec-rails'
  gem 'factory_girl_rails'
end

# Production
group :production do
  gem 'pg'
end

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails', "4.0.2"
  gem 'coffee-rails'
  gem 'uglifier'
end