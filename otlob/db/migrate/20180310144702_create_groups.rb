class CreateGroups < ActiveRecord::Migration[5.1]
  def change
    create_table :groups do |t|
      t.string :name

      t.timestamps
    end

    create_join_table :groups, :users do |t|
	    t.index :group_id
	    t.index :user_id
	  end
  end
end
