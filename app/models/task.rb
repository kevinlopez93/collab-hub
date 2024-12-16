class Task < ApplicationRecord
  include TaskAasm

  belongs_to :board
  belongs_to :creator, class_name: "User", foreign_key: "creator_id"

  has_many :user_tasks, dependent: :destroy
  has_many :users_assigned, through: :user_tasks, source: :user

  validates :title, presence: true

  def self.ransackable_attributes(auth_object = nil)
    %w[id title description workflow_status created_at updated_at]
  end
end
