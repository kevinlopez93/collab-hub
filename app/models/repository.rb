class Repository < ApplicationRecord
  belongs_to :project, optional: true
  belongs_to :user, optional: true

  def self.ransackable_attributes(auth_object = nil)
    %w[id name created_at updated_at remote_id node_id full_name owner_login description url_api url_html remote_created_at remote_updated_at visibility language]
  end
end
