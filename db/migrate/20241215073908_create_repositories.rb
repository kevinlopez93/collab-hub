class CreateRepositories < ActiveRecord::Migration[8.0]
  def change
    create_table :repositories do |t|
      t.string :remote_id
      t.string :node_id
      t.string :name
      t.string :full_name
      t.boolean :private
      t.string :owner_login
      t.text :description
      t.string :url_api
      t.string :url_html
      t.datetime :remote_created_at
      t.datetime :remote_updated_at
      t.string :visibility
      t.string :language
      t.references :project, foreign_key: true

      t.timestamps
    end
  end
end
