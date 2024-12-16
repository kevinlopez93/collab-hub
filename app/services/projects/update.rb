module Projects
  class Update
    attr_reader :project, :params, :repositories_assigned

    def initialize(project, params, repositories_assigned = [])
      @project = project
      @params = params
      @repositories_assigned = repositories_assigned
    end

    def call
      update_project
      update_repositories_assignments
    end

    private

    def update_project
      project.update(params)
    end

    def update_repositories_assignments
      Repository.where(id: repositories_assigned).update_all(project_id: project.id)
    end
  end
end
