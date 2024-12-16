class AddCreatedByToProject < ActiveRecord::Migration[8.0]
  def change
    add_reference :projects, :created_by, foreign_key: { to_table: :users }, null: false
  end
end
