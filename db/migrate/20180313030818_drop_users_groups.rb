class DropUsersGroups < ActiveRecord::Migration[5.1]
  def change
  	drop_table :users_groups
  end
end
