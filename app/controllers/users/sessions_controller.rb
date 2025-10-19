class Users::SessionsController < Devise::SessionsController
  respond_to :html, :json

  # POST /users/sign_in
  def create
    super do |resource|
      # Only set cookie if JWT token exists (devise-jwt does this automatically)
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
      # Do not yield or break; just end super
    end
  end

  # DELETE /users/sign_out
  def destroy
    super do
      cookies.delete(:jwt)
    end
  end
end
