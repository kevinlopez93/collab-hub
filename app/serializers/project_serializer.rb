class ProjectSerializer < ActiveModel::Serializer
  attributes :id, :name, :created_at, :updated_at, :description

  belongs_to :created_by, serializer: UserSerializer
  has_many :boards, serializer: BoardSerializer
end
