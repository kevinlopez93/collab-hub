class AddGithubCredentialsToUser < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :github_credentials, :jsonb, default: {}
  end
end
