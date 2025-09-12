# frozen_string_literal: true

Devise.setup do |config|
  # Use Rails credentials for secret key in development
  config.secret_key = Rails.application.credentials.secret_key_base if Rails.env.development?

  # Default sender for Devise mailers
  config.mailer_sender = 'please-change-me-at-config-initializers-devise@example.com'

  # Load Active Record ORM
  require 'devise/orm/active_record'

  # Case-insensitive keys
  config.case_insensitive_keys = [:email]

  # Strip whitespace from keys
  config.strip_whitespace_keys = [:email]

  # Skip session storage for http_auth
  config.skip_session_storage = [:http_auth]

  # Bcrypt stretches
  config.stretches = Rails.env.test? ? 1 : 12

  # Reconfirmable (require revalidation for email change)
  config.reconfirmable = true

  # Expire remember me tokens on sign out
  config.expire_all_remember_me_on_sign_out = true

  # Password length
  config.password_length = 6..128

  # Email regex
  config.email_regexp = /\A[^@\s]+@[^@\s]+\z/

  # Reset password window
  config.reset_password_within = 6.hours

  # Sign out via DELETE
  config.sign_out_via = :delete

  # API-only tweak: don’t use navigational formats (prevents Devise from redirecting on JSON requests)
  config.navigational_formats = []

  # Hotwire/Turbo responder settings
  config.responder.error_status = :unprocessable_entity
  config.responder.redirect_status = :see_other
end
