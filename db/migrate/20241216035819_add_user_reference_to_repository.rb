class AddUserReferenceToRepository < ActiveRecord::Migration[8.0]
  def change
    add_reference :repositories, :user, foreign_key: true
  end
end
