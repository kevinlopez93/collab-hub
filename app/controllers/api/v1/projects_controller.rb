class Api::V1::ProjectsController < ApplicationController
  before_action :set_project, only: %i[show update destroy statistics]

  def index
    projects = policy_scope(Project).ransack(params[:q]).result
    @pagy, records = pagy(projects)
    render json: records, each_serializer: ProjectSerializer, status: :ok
  end

  def show
    authorize @project
    render json: { project: ProjectSerializer.new(@project) }, status: :ok
  end

  def create
    project = Projects::Create.new(project_params, current_user).call

    if project.persisted?
      render json: { project: ProjectSerializer.new(project) }, status: :ok
    else
      render json: { errors: project.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    authorize @project

    service = Projects::Update.new(@project, project_params, repositories_assigned)
    if service.call
      render json: { project: ProjectSerializer.new(@project) }, status: :ok
    else
      render json: { errors: @project.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @project
    @project.destroy!
    render json: { project: ProjectSerializer.new(@project) }, status: :ok
  end

  # GET /projects/:id/statistics
  def statistics
    authorize @project

    render json: @project, serializer: Projects::StatisticsSerializer, status: :ok
  end

  private

  def set_project
    @project = Project.find(params[:id])
  end

  def project_params
    params.require(:project).permit(:name, :description)
  end

  def repositories_assigned
    params[:repositories_assigned] || []
  end

  def validate_repository_ids!
    invalid_ids = repositories_assigned - Repository.pluck(:id)
    raise ActiveRecord::RecordNotFound, "Invalid user IDs: #{invalid_ids.join(', ')}" if invalid_ids.any?
  end
end
