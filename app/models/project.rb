class Project < ApplicationRecord
  belongs_to :created_by, class_name: "User", foreign_key: "created_by_id"

  validates :name, presence: true

  has_many :boards, dependent: :destroy
  has_many :tasks, through: :boards
  has_many :repositories, dependent: :nullify

  def self.ransackable_attributes(auth_object = nil)
    %w[id name created_at updated_at]
  end
end
