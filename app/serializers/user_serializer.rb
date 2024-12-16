class UserSerializer < ActiveModel::Serializer
  attributes :username, :email, :role, :github_credentials

  def role
    object.role_humanize
  end
end