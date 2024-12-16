class ApplicationController < ActionController::API
  include JwtManager
  include Pundit::Authorization
  include Pagy::Backend

  before_action :jwt_authenticate!

  after_action { pagy_headers_merge(@pagy) if @pagy }

  rescue_from ActiveRecord::RecordNotUnique, with: :handle_record_not_unique
  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  rescue_from Pundit::NotAuthorizedError, with: :not_authorized

  private 

  def handle_record_not_unique(exception)
    render json: { errors: exception.message }, status: :unprocessable_entity
  end

  def not_found(exception)
    render json: { error: exception.message }, status: :not_found
  end

  def not_authorized
    render json: { error: 'Not authorized' }, status: :unauthorized
  end

  def current_user
    @current_user ||= get_token.present? ? current_user_jwt : nil
  end

  def json_response(response:, status: :ok)
    Rails.logger.debug(response) if Rails.env.development?

    render json: response, status: status
  end
end
