class Board < ApplicationRecord
  belongs_to :project
  belongs_to :created_by, class_name: "User", foreign_key: "created_by_id"

  has_many :tasks, dependent: :destroy

  def self.ransackable_attributes(auth_object = nil)
    # Lista explícita de columnas permitidas
    %w[id name created_at updated_at]
  end
end
