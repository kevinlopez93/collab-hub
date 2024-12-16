class Api::V1::TasksController < ApplicationController
  before_action :set_task, only: %i[show update destroy update_states]
  before_action :validate_user_ids!, only: %i[create update]

  def index
    tasks = policy_scope(Task).ransack(params[:q]).result
    @pagy, records = pagy(tasks)
    render json: records, each_serializer: TaskSerializer, status: :ok
  end

  def show
    authorize @task
    render json: { task: TaskSerializer.new(@task) }, status: :ok
  end

  def create
    authorize Task
    
    task = Tasks::Create.new(task_params, current_user, users_assigned).call

    if task.persisted?
      render json: { task: TaskSerializer.new(task) }, status: :ok
    else
      render json: { errors: task.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    authorize @task

    service = Tasks::Update.new(@task, task_params, users_assigned)
    if service.call
      render json: { task: TaskSerializer.new(@task) }, status: :ok
    else
      render json: { errors: @task.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update_states
    authorize @task

    service = Tasks::UpdateStates.new(@task, task_params[:event]).call
    if service[:result]
      render json: { task: TaskSerializer.new(@task) }, status: :ok
    else
      render json: { errors: service[:errors] }, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @task
    @task.destroy
    render json: { task: TaskSerializer.new(@task) }, status: :ok
  end

  private

  def set_task
    @task = Task.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:title, :description, :due_date, :board_id, :event)
  end

  def users_assigned
    params[:users_assigned] || []
  end

  def validate_user_ids!
    invalid_ids = users_assigned - User.pluck(:id)
    raise ActiveRecord::RecordNotFound, "Invalid user IDs: #{invalid_ids.join(', ')}" if invalid_ids.any?
  end
end
