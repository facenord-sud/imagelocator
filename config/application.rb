require File.expand_path('../boot', __FILE__)

# Pick the frameworks you want:
require "active_model/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "sprockets/railtie"
require 'rubygems'
require 'sparql/client'

# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Imagelocator
  class Application < Rails::Application

     config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}').to_s]
     config.i18n.default_locale = :en
     config.time_zone = 'Paris'
     config.i18n.available_locales = [:fr, :en, :de]
     config.encoding = 'utf-8'
     config.i18n.fallbacks = true

     config.assets.paths << Rails.root.join('app', 'assets', 'fonts')
     config.assets.precompile += %w(.svg .eot .woff .ttf)

     # Configure sensitive parameters which will be filtered from the log fichier.
     config.filter_parameters += [:password]
  end
  Globalize.fallbacks = {en: [:en, :fr, :de], fr: [:fr, :en, :de], de: [:de, :en, :fr]}
end
