class RepositorySerializer < ActiveModel::Serializer
  attributes :id, :remote_id, :name, :description, :remote_created_at, :remote_updated_at, :url_html
end
