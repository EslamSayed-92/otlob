class CreateUsersGroupsJoinTable < ActiveRecord::Migration[5.1]
  def change
  	create_table :users_groups, id: false do |t|
      t.integer :user_id, index: true
      t.integer :group_id, index: true
    end
  end
end
