class CreateTasks < ActiveRecord::Migration[8.0]
  def change
    create_table :tasks do |t|
      t.string :title
      t.text :description
      t.references :board, null: false, foreign_key: true
      t.references :creator, foreign_key: { to_table: :users }, null: false
      t.string :workflow_status, default: TaskStatus::TODO
      t.datetime :due_date

      t.timestamps
    end
  end
end
