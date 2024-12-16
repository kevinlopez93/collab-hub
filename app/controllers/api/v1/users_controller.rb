class Api::V1::UsersController < ApplicationController
  skip_before_action :jwt_authenticate!, only: :create
  before_action :set_user, only: %i[update show]

  # GET api/v1/users
  def index
    users = policy_scope(User).ransack(params[:q]).result
    @pagy, records = pagy(users, items: params[:per_page] || 5)
    render json: records, each_serializer: UserSerializer, status: :ok
  end

  # POST api/v1/users
  def create
    user = Users::Create.new(user_params).call

    if user.persisted?
      json_response(response: {
        user: UserSerializer.new(user),
        token: JsonWebToken.generate_token(user)
      }, status: :ok)
    else
      json_response(response: { errors: user.errors.full_messages }, status: :unprocessable_entity)
    end
  end

  # PUT api/v1/users/:username
  def update
    authorize @user

    service = Users::Update.new(@user, user_params)
    if service.call
      json_response(response: { user: UserSerializer.new(@user) }, status: :ok)
    else
      json_response(response: { errors: @user.errors.full_messages }, status: :unprocessable_entity)
    end
  end

  # GET api/v1/users/:username
  def show
    authorize @user
    json_response(response: { user: UserSerializer.new(@user) }, status: :ok)
  end

  private

  def user_params
    allowed_params = [:username, :email, :password]
    allowed_params << :role if current_user&.admin?
    params.require(:user).permit(*allowed_params)
  end

  def set_user
    @user = User.find_by_username!(params[:username])
    authorize @user
  end
end
