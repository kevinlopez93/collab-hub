class RepositoryPolicy < ApplicationPolicy
  def index?
    true
  end

  class Scope < Scope
    def resolve
      return scope.all if user.admin? || user.project_manager?

      scope.where(user_id: user.id)
    end
  end
end
