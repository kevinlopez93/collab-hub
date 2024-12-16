class Api::V1::AuthController < ApplicationController
  skip_before_action :jwt_authenticate!, only: %i[create oauth_authorize]

  # POST /login
  def create
    user = User.find_by(username: params[:username])

    if user&.authenticate(params[:password])
      render json: { token: JsonWebToken.generate_token(user), user: UserSerializer.new(user) }, status: :ok
    else
      render json: { error: 'Invalid username or password' }, status: :unauthorized
    end
  end

  # PUT /oauth/authorize
  def oauth_authorize
    AccessTokenGeneratorJob.perform_later(params[:code], params[:state])
    head :no_content
  end
end