# app/controllers/application_controller.rb
class ApplicationController < ActionController::API
  include ActionController::Cookies
  include ActionController::RequestForgeryProtection
  include DeviseTokenAuth::Concerns::SetUserByToken

  # For API requests, use null_session to avoid CSRF/session errors
    protect_from_forgery with: :null_session, if: -> { request.format.json? }

  # Skip session storage for Devise (API mode)
  before_action :skip_session_storage



  # Allow extra parameters for Devise (optional)
  before_action :configure_permitted_parameters, if: :devise_controller?

  private

  def skip_session_storage
    request.session_options[:skip] = true
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:email, :password, :password_confirmation])
    devise_parameter_sanitizer.permit(:account_update, keys: [:email, :password, :password_confirmation])
  end
end
