# app/controllers/application_controller.rb
class ApplicationController < ActionController::API
  include ActionController::Cookies
  include ActionController::RequestForgeryProtection
  include DeviseTokenAuth::Concerns::SetUserByToken

  # ✅ CSRF handling for API/JSON requests
  protect_from_forgery with: :null_session, if: -> { request.format.json? }

  # ✅ Avoid storing session in API mode
  before_action :skip_session_storage

  # ✅ Allow extra Devise params (name, etc.)
  before_action :configure_permitted_parameters, if: :devise_controller?

  private

  def skip_session_storage
    request.session_options[:skip] = true
  end

  protected

  def configure_permitted_parameters
    # For sign up
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :email, :password, :password_confirmation])

    # For account update (PUT/PATCH /auth)
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :email, :password, :password_confirmation])
  end
end
