class AddCreatedByToBoard < ActiveRecord::Migration[8.0]
  def change
    add_reference :boards, :created_by, foreign_key: { to_table: :users }
  end
end
