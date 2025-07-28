require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Wsock
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 8.0

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w[assets tasks])

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    websocket_url = ENV['WEB_SOCKET_URL'] || 'ws://localhost:8080'

    # Set Content-Security-Policy headers
    # config.action_dispatch.default_headers.merge!(
    #  'Content-Security-Policy' => "default-src 'self'; connect-src 'self' #{websocket_url};"
    # )

    Rails.application.config.content_security_policy do |policy|
      policy.default_src :self
      policy.connect_src :self, websocket_url
      policy.script_src :self, -> { "'nonce-#{content_security_policy_nonce}'" }
      # add other directives you need, like style_src, img_src etc.
    end

    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins '*'
        resource '*',
          headers: :any,
          methods: [:get, :post, :options],
          expose: ['Content-Security-Policy'],
          credentials: false
      end
    end  
  end
  
end
