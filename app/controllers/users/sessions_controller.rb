class Users::SessionsController < Devise::SessionsController
  respond_to :html, :json

  def create
    super do |resource|
      token = request.env['warden-jwt_auth.token']
      if token.present?
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
