class BoardSerializer < ActiveModel::Serializer
  attributes :id, :name, :created_at, :updated_at

  belongs_to :created_by, serializer: UserSerializer
  belongs_to :project, key: :assigned_project, serializer: ProjectSerializer
  has_many :tasks, serializer: TaskSerializer
end
