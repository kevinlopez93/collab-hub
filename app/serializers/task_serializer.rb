class TaskSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :workflow_status, :created_at, :updated_at, :due_date

  belongs_to :creator, serializer: UserSerializer
  belongs_to :board, serializer: BoardSerializer

  has_many :users_assigned, serializer: UserSerializer

  def workflow_status
    I18n.t("task.statuses.#{object.workflow_status}")
  end
end