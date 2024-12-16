module Projects
  class StatisticsSerializer < ActiveModel::Serializer
    attributes :id, :name, :boards_count, :tasks_count

    has_many :repositories, serializer: RepositorySerializer

    def boards_count
      object.boards.count
    end

    def tasks_count
      object.tasks.count
    end
  end
end
