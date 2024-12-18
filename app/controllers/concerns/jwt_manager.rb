module JwtManager
  extend ActiveSupport::Concern

  def jwt_authenticate!
    @decoded_token = JsonWebToken.decode(get_token)
  rescue JWT::DecodeError, ActiveRecord::RecordNotFound
    invalid_token
  end

  def decoded_token
    @decoded_token ||= jwt_authenticate!
  end

  def get_token
    request.env["HTTP_AUTHORIZATION"].try(:split, " ").try(:second) || request.params[:http_authorization]
  end

  def current_user_jwt
    User.find_by_email!(decoded_token[:email])
  rescue ActiveRecord::RecordNotFound
    invalid_token
  end

  def invalid_token
    render json: { error: "Invalid token or user not found" }, status: :unauthorized
  end
end
