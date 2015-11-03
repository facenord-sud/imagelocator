source 'https://rubygems.org'


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.1.6'
# Use postgresql as the database for Active Record
gem 'mysql2'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.3'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer',  platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
#gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0',          group: :doc

# Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
gem 'spring',        group: :development

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# NUMA
gem 'kaminari', '~> 0.16.1' # pagination
gem 'zurb-foundation' # framework html, css, js
gem 'simple_form' # forms
gem 'haml' # genère du html
gem 'foundation-icons-sass-rails' # icones sympas
gem 'mini_magick' # redimensionne les images. Sous os x installer le programme c avec brew install imagemagick

gem 'carrierwave' # file upload

gem 'devise' # user management
gem 'omniauth' # user connect api
gem 'omniauth-facebook'
gem 'omniauth-google-oauth2'

gem 'devise-i18n-views' # translation user management view
gem 'rails-i18n', '~> 4.0.0' # translation (numbers etc)
gem 'i18n' # translation library
gem 'route_translator'

gem 'enumerize' # enumerations in models

group :production do
  gem 'rails_12factor'
  gem 'unicorn'
  gem 'thin' #server
end

gem 'gmaps4rails'
gem 'spinjs-rails'
gem 'masonry-rails'

# modal
gem 'jquery-ui-rails'
gem 'jquery-modal-rails'


group :development do
  gem 'binding_of_caller'
  gem 'magic_encoding'
  gem 'annotate', :git => 'git://github.com/ctran/annotate_models.git'
  gem 'better_errors'
  gem 'quiet_assets'
  gem 'rails-erd'
  gem 'meta_request'
  gem 'byebug'
end

group :test do
  gem 'sqlite3'
  gem 'capybara', '~> 2.4.3'
  gem 'capybara-webkit'
  gem 'factory_girl_rails', '4.1.0'
  gem 'cucumber-rails', '1.2.1', :require => false
  gem 'database_cleaner', "~> 1.2.0"
  gem 'lorem-ipsum'
  gem 'rspec-rails'
  gem 'childprocess'
end

# for debian 7
gem 'execjs'
gem 'therubyracer'

# for SPARQL DBPEDIA
gem 'activerdf'
gem 'activerdf_sparql'
gem 'sparql'
#gem 'debugger'
gem 'select2-rails', '~> 3.5.9.1'
gem 'globalize', '~> 4.0.2'