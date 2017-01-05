require_relative 'boot'

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "action_cable/engine"
# require "sprockets/railtie"
require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module SendSnapApi
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Only loads a smaller set of middleware suitable for API only apps.
    # Middleware like session, flash, cookies can be added back manually.
    # Skip views, helpers and assets when generating a new resource.
    config.api_only = true
    ActiveModel::Serializer.config.adapter = :attributes
    config.active_record.primary_key = :uuid

    CarrierWave.configure do |config|
      config.permissions = 0666
      config.directory_permissions = 0777
      config.storage = :file
    end

    if Rails.env.test? or Rails.env.cucumber?
      CarrierWave.configure do |config|
        config.storage = :file
        config.enable_processing = false
      end
    end
  end
end
