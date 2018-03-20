class CreateGroupsUsersJoinTable < ActiveRecord::Migration[5.1]
  def change
    create_join_table :groups, :users do |t|
      t.index :group_id
      t.index :user_id
    end
  end
end
