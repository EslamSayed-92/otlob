class RemoveGroupFromUser < ActiveRecord::Migration[5.1]
  def change
    remove_reference :users, :group, foreign_key: true
  end
end
