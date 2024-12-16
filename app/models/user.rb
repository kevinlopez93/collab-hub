class User < ApplicationRecord
  include Tokenable

  has_secure_password

  validates :username, presence: true
  validates :email, presence: true

  validates :username, uniqueness: true
  validates :email, uniqueness: true

  has_enumeration_for :role, with: RoleUserEnum, create_helpers: true

  has_many :created_tasks, class_name: "Task", foreign_key: "creator_id", dependent: :nullify
  has_many :created_projects, class_name: "Project", foreign_key: "created_by_id", dependent: :nullify
  has_many :created_boards, class_name: "Board", foreign_key: "created_by_id", dependent: :nullify

  has_many :user_tasks
  has_many :assigned_tasks, through: :user_tasks, source: :task

  has_many :repositories, dependent: :nullify

  def self.ransackable_attributes(auth_object = nil)
    %w[id username email created_at updated_at]
  end

  def generate_jwt
    JsonWebToken.generate_token(self)
  end
end
