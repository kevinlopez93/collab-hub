module Tasks
  class Update
    attr_reader :task

    def initialize(task, params, users_assigned)
      @task = task
      @params = params
      @users_assigned = users_assigned
    end

    def call
      ActiveRecord::Base.transaction do
        update_task
        update_user_assignments
        task
      end
    rescue ActiveRecord::RecordInvalid => e
      false
    end

    private

    def update_task
      task.update!(@params.except(:event))
    end

    def update_user_assignments
      # Elimina relaciones no incluidas
      task.user_tasks.where.not(user_id: user_ids).destroy_all 

      existing_user_ids = task.user_tasks.pluck(:user_id)

      # Solo agrega los que no existen
      new_user_ids = user_ids - existing_user_ids
      new_user_ids.each { |id| task.user_tasks.create!(user_id: id) }
    end

    def user_ids
      @users_assigned || []
    end
  end
end