class ApplicationController < ActionController::Base
  # Only allow modern browsers
  # This ensures your app uses features like WebP images, web push, badges, import maps, CSS nesting, and the CSS :has() selector
  allow_browser versions: :modern

  # CSRF protection for forms and requests
  protect_from_forgery with: :exception

  # Before every action, attach JWT from cookie (if present) to Authorization header
  # This allows Devise JWT to authenticate the user if the session is missing
  before_action :attach_jwt_from_cookie_to_header

  private

  # Copy JWT token from encrypted cookie to Authorization header
  # Devise JWT middleware looks for this header to verify the token
  def attach_jwt_from_cookie_to_header
    # Skip if header already exists (API clients may already send it)
    return if request.headers['Authorization'].present?

    # Read JWT token from encrypted cookie
    jwt = cookies.encrypted[:jwt]
    return if jwt.blank?

    # Set header so Devise JWT middleware can authenticate user
    request.headers['Authorization'] = "Bearer #{jwt}"
  end
end
