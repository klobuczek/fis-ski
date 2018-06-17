source 'http://rubygems.org'
# ruby '2.2.0'

gem 'rails', '>= 5.0.0'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'mysql2'

# Use SCSS for stylesheets
gem 'sass-rails', '>= 5.0.5'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 2.7.2'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '>= 4.1.1'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails', '>= 4.0.4'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks', '>= 5.0.0'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '>= 2.2.12'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', group: :doc

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Unicorn as the app server
# gem 'unicorn'

gem 'nokogiri', '>= 1.8.2'
# gem 'sqlite3-ruby', :require => 'sqlite3'
# gem 'aws-s3', :require => 'aws/s3'

# Bundle gems for the local environment. Make sure to
# put test-only gems in this group so their generators
# and rake tasks are available in development mode:
# group :development, :test do
#   gem 'webrat'
# end

gem "haml", ">= 5.0.0"
gem 'bootstrap-sass'
gem 'autoprefixer-rails'
gem "devise", ">= 4.0.0"
gem 'whenever', :require => false
gem 'simple_form', '>= 3.1.0'
gem 'active_attr', '>= 0.8.5'
gem 'spawnling'

group :development do
# Use Capistrano for deployment
  gem 'capistrano-rails'
  gem 'capistrano-rvm'
  gem 'capistrano-passenger'
end

#test
group :test, :development do
  gem "rspec-rails", ">= 3.5.0"

  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  # gem 'byebug'

  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '>= 2.1.3'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem "transpec", ">= 3.1.0"
end

group :test do
  gem 'factory_girl_rails', '>= 4.5.0'
  gem 'capybara', '>= 2.4.4'
  gem 'database_cleaner'
  gem 'launchy'
  gem 'selenium-webdriver', '>= 2.45.0'
end

