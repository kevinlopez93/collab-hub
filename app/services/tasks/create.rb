module Tasks
  class Create
    def initialize(params, current_user, users_assigned = [])
      @params = params
      @current_user = current_user
      @users_assigned = users_assigned
    end

    def call
      ActiveRecord::Base.transaction do
        task = create_task
        crate_user_tasks(task) if task.persisted? && user_ids.present?
  
        task
      end
    end

    private

    def create_task
      Task.create(task_params)
    end

    def task_params
      @params.merge!(creator: @current_user)
    end

    def crate_user_tasks(task)
      user_ids.each { |id| task.user_tasks.create!(user_id: id) }
    end

    def user_ids
      @users_assigned || []
    end
  end
end