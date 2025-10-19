# app/controllers/users/sessions_controller.rb
class Users::SessionsController < Devise::SessionsController
  # Keep HTML responses so your normal web flows remain intact
  respond_to :html, :json

  # POST /users/sign_in
  def create
    super do |resource|
      token = request.env['warden-jwt_auth.token']
      if token.present?
        # store encrypted cookie (HttpOnly)
        cookies.encrypted[:jwt] = {
          value: token,
          httponly: true,
          secure: Rails.env.production?,
          same_site: :lax,
          expires: Time.current + Devise.jwt.expiration_time.seconds
        }
      end
      break
    end
  end

  def destroy
    super do
      cookies.delete(:jwt)
    end
  end
end
