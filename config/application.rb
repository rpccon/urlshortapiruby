require_relative 'boot'

require 'rails/all'

# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Urlshortapiruby
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2
    config.action_dispatch.default_headers = {
      'Access-Control-Allow-Origin' => '*',
      'Access-Control-Request-Method' => %w{GET POST OPTIONS}.join(",")
    }    
    config.middleware.insert_before 0, "Rack::Cors" do
      allow do
          origins '*' #-> has to be "*" or specific
          resource '*', headers: :any, methods: [:get, :post, :options]
      end
    end
    config.assets.initialize_on_precompile = false
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
  end
end
