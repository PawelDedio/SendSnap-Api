source 'https://rubygems.org'


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.0.0', '>= 5.0.0.1'
# Use Puma as the app server
gem 'puma', '~> 3.0'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
# gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'

# Use ActiveModel has_secure_password
 gem 'bcrypt', '~> 3.1.7'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
# gem 'rack-cors'

gem 'pg', '~> 0.18.2'

# permission manager https://github.com/CanCanCommunity/cancancan/
gem 'cancancan', '~> 1.10'

#email validator https://github.com/balexand/email_validator
gem 'email_validator', '~> 1.6.0'

gem 'active_model_serializers', '0.9.3'

#https://github.com/mislav/will_paginate
gem 'kaminari', '~> 0.17.0'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platform: :mri
  gem 'rspec-rails', '~> 3.5.2'
  gem 'rspec-collection_matchers', '~> 1.1.2'
  gem 'rspec-its', '~> 1.2.0'
  gem 'factory_girl_rails', '~> 4.7.0'
  gem 'faker', '~> 1.6.6'
  gem 'annotate', '~> 2.7.1'
end

group :development do
  gem 'listen', '~> 3.0.5'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  gem 'shoulda-matchers', '~> 3.1.1', require: false
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
