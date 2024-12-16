class Api::V1::RepositoriesController < ApplicationController

  def index
    repositories = policy_scope(Repository).ransack(params[:q]).result
    @pagy, records = pagy(repositories)
    render json: records, each_serializer: RepositorySerializer, status: :ok
  end
end
