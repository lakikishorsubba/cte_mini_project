class Users::SessionsController < Devise::SessionsController
  respond_to :html, :json

  def create
    super do |resource|
      if request.env['warden-jwt_auth.token'].present?
        token = request.env['warden-jwt_auth.token']

        cookies[:jwt] = {
          value: token,
          httponly: true,
          secure: Rails.env.production?, # only HTTPS in production
          same_site: :lax,
          expires: Time.current + 30.minutes
        }
      end
    end
  end

  # DELETE /users/sign_out
  def destroy
    super do
      cookies.delete(:jwt)
    end
  end
end
