require_relative "boot"
require "rails/all"

# Require the gems listed in Gemfile
Bundler.require(*Rails.groups)

module GalleryApi
  class Application < Rails::Application
    # Initialize configuration defaults for Rails 8
    config.load_defaults 8.0

    # API-only mode: skips views, helpers, assets by default
    config.api_only = true

    # Add back middleware needed for cookies and session support
    config.middleware.use ActionDispatch::Cookies
    config.middleware.use ActionDispatch::Session::CookieStore, key: '_gallery_api_session'

    # Optional: allow CSRF protection if using cookies
    config.middleware.use ActionDispatch::Flash

    # Autoload /lib except non-Ruby directories
    config.autoload_lib(ignore: %w[assets tasks])
  end
end
